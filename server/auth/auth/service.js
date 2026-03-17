import crypto from 'crypto';
import jwt from 'jsonwebtoken';
import { v4 as uuidv4 } from 'uuid';
import dotenv from 'dotenv';
import { pool } from '../common/db.js';
import { redisClient } from '../common/redis.js';
import {
  USER_LOOKUP_ORDER,
  USER_ROLES,
  getUserIdColumnByRole,
  getUserSafeColumnsByRole,
  getUserTableByRole,
  isSupportedRole,
  normalizeRole,
} from '../common/userColumns.js';

dotenv.config({ path: new URL('../.env', import.meta.url), override: true });

if (!process.env.JWT_SECRET) {
  throw new Error('JWT_SECRET environment variable is required');
}

const JWT_SECRET = process.env.JWT_SECRET;
const ACCESS_EXPIRES = process.env.JWT_EXPIRES_IN || '15m';
const REFRESH_DAYS = Number(process.env.REFRESH_TOKEN_EXPIRES_DAYS || 30);
const OTP_TTL_SECONDS = Number(process.env.OTP_TTL_SECONDS || 300);
const OTP_DIGITS = Number(process.env.OTP_DIGITS || 4);
const RETURN_OTP =
  process.env.OTP_RETURN_IN_RESPONSE === 'true' || process.env.NODE_ENV !== 'production';

function resolveOtpTtlSeconds() {
  return Number.isFinite(OTP_TTL_SECONDS) && OTP_TTL_SECONDS > 0 ? OTP_TTL_SECONDS : 300;
}

function resolveOtpDigits() {
  return Number.isInteger(OTP_DIGITS) && OTP_DIGITS > 0 && OTP_DIGITS <= 10 ? OTP_DIGITS : 6;
}

function generateOtp() {
  const digits = resolveOtpDigits();
  const max = 10 ** digits;
  return String(crypto.randomInt(0, max)).padStart(digits, '0');
}

function otpKey(phoneNo) {
  return `otp:${phoneNo}`;
}

function signAccessToken(payload) {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: ACCESS_EXPIRES });
}

function signRefreshToken() {
  return uuidv4();
}

function refreshTokenKey(refreshToken) {
  return `refresh:${refreshToken}`;
}

function parseRefreshTokenState(state) {
  if (!state) return null;

  try {
    const parsed = JSON.parse(state);
    if (parsed && parsed.userId) {
      return {
        userId: String(parsed.userId),
        role: normalizeRole(parsed.role),
      };
    }
  } catch {
    return { userId: String(state), role: null };
  }

  return { userId: String(state), role: null };
}

function serializeRefreshTokenState(user) {
  return JSON.stringify({ userId: user.id, role: user.role });
}

async function findUserByIdAndRole(userId, role) {
  const normalizedRole = normalizeRole(role);
  if (!normalizedRole) return null;

  const table = getUserTableByRole(normalizedRole);
  const idColumn = getUserIdColumnByRole(normalizedRole);
  const safeColumns = getUserSafeColumnsByRole(normalizedRole);
  const sql = `SELECT ${safeColumns} FROM ${table} WHERE ${idColumn}=$1`;
  const result = await pool.query(sql, [userId]);
  return result.rows[0] ?? null;
}

async function findUserByIdAcrossRoles(userId) {
  for (const role of USER_LOOKUP_ORDER) {
    const user = await findUserByIdAndRole(userId, role);
    if (user) return user;
  }
  return null;
}

export function shouldReturnOtp() {
  return RETURN_OTP;
}

export async function createUser({ phoneNo, name, role = USER_ROLES.RIDER }) {
  const normalizedRole = normalizeRole(role) || USER_ROLES.RIDER;
  const table = getUserTableByRole(normalizedRole);
  const safeColumns = getUserSafeColumnsByRole(normalizedRole);

  const columns = ['phone_no'];
  const values = [phoneNo];

  if (name !== undefined) {
    columns.push('name');
    values.push(name);
  }

  if (normalizedRole === USER_ROLES.DRIVER) {
    columns.push('onboarding_status');
    values.push('info_remaining');
  }

  const placeholders = values.map((_, index) => `$${index + 1}`).join(', ');
  const sql = `INSERT INTO ${table} (${columns.join(', ')}) VALUES (${placeholders}) RETURNING ${safeColumns}`;
  const result = await pool.query(sql, values);
  return result.rows[0];
}

export async function findUserByPhone(phoneNo, role) {
  const normalizedRole = normalizeRole(role);
  const rolesToTry = normalizedRole ? [normalizedRole] : USER_LOOKUP_ORDER;

  for (const candidateRole of rolesToTry) {
    const table = getUserTableByRole(candidateRole);
    const safeColumns = getUserSafeColumnsByRole(candidateRole);
    const sql = `SELECT ${safeColumns} FROM ${table} WHERE phone_no=$1`;
    const result = await pool.query(sql, [phoneNo]);
    if (result.rows[0]) return result.rows[0];
  }

  return null;
}

export async function requestOtp(phoneNo) {
  const otp = generateOtp();
  const ttlSeconds = resolveOtpTtlSeconds();
  await redisClient.set(otpKey(phoneNo), otp, { EX: ttlSeconds });
  return { otp, expiresIn: ttlSeconds };
}

export async function verifyOtp(phoneNo, otp) {
  const key = otpKey(phoneNo);
  const stored = await redisClient.get(key);
  if (!stored) return false;

  const storedBuffer = Buffer.from(stored);
  const otpBuffer = Buffer.from(otp);
  if (storedBuffer.length !== otpBuffer.length) return false;

  const matches = crypto.timingSafeEqual(storedBuffer, otpBuffer);
  if (!matches) return false;

  await redisClient.del(key);
  return true;
}

export async function issueTokens(user) {
  const accessToken = signAccessToken({ sub: user.id, role: user.role });
  const refreshToken = signRefreshToken();

  await redisClient.set(refreshTokenKey(refreshToken), serializeRefreshTokenState(user), {
    EX: REFRESH_DAYS * 24 * 60 * 60,
  });

  return { accessToken, refreshToken, expiresIn: ACCESS_EXPIRES };
}

export async function refreshAccessToken(refreshToken) {
  const key = refreshTokenKey(refreshToken);
  const state = await redisClient.get(key);
  if (!state) throw new Error('Invalid refresh token');

  const parsedState = parseRefreshTokenState(state);
  if (!parsedState?.userId) throw new Error('Invalid refresh token');

  let user = null;
  if (parsedState.role && isSupportedRole(parsedState.role)) {
    user = await findUserByIdAndRole(parsedState.userId, parsedState.role);
  }

  if (!user) {
    user = await findUserByIdAcrossRoles(parsedState.userId);
  }

  if (!user) throw new Error('User not found');

  await redisClient.del(key);
  const newRefreshToken = signRefreshToken();

  await redisClient.set(
    refreshTokenKey(newRefreshToken),
    serializeRefreshTokenState(user),
    {
      EX: REFRESH_DAYS * 24 * 60 * 60,
    }
  );

  const accessToken = signAccessToken({ sub: user.id, role: user.role });
  return { accessToken, refreshToken: newRefreshToken };
}

export async function revokeRefreshToken(refreshToken) {
  await redisClient.del(refreshTokenKey(refreshToken));
}

export async function deleteUserById(userId, role) {
  const normalizedRole = normalizeRole(role);
  const rolesToTry = normalizedRole ? [normalizedRole] : USER_LOOKUP_ORDER;

  for (const candidateRole of rolesToTry) {
    const table = getUserTableByRole(candidateRole);
    const idColumn = getUserIdColumnByRole(candidateRole);
    const sql = `DELETE FROM ${table} WHERE ${idColumn}=$1 RETURNING ${idColumn}`;
    const result = await pool.query(sql, [userId]);
    if (result.rows[0]) return true;
  }

  return false;
}
