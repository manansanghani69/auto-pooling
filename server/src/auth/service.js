// src/auth/service.js
import bcrypt from 'bcrypt';
import crypto from 'crypto';
import jwt from 'jsonwebtoken';
import { pool } from '../common/db.js';
import { redisClient } from '../common/redis.js';
import { v4 as uuidv4 } from 'uuid';
import dotenv from 'dotenv';
dotenv.config();

const SALT_ROUNDS = 10;
const JWT_SECRET = process.env.JWT_SECRET;
const ACCESS_EXPIRES = process.env.JWT_EXPIRES_IN || '15m';
const REFRESH_DAYS = Number(process.env.REFRESH_TOKEN_EXPIRES_DAYS || 30);
const OTP_TTL_SECONDS = Number(process.env.OTP_TTL_SECONDS || 300);
const OTP_DIGITS = Number(process.env.OTP_DIGITS || 4);
const RETURN_OTP = process.env.OTP_RETURN_IN_RESPONSE === 'true' || process.env.NODE_ENV !== 'production';
const USER_SAFE_COLUMNS = 'id, phone, name, email, profile_photo, gender, role, created_at';

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

function otpKey(phone) {
    return `otp:${phone}`;
}

export function shouldReturnOtp() {
    return RETURN_OTP;
}

async function hashPlaceholderPassword() {
    // Keep legacy password column populated even though OTP is used.
    return bcrypt.hash(uuidv4(), SALT_ROUNDS);
}

export async function createUser({ phone, name, role = 'rider' }) {
    const hashed = await hashPlaceholderPassword();
    const sql = `INSERT INTO users (phone, name, password, role) VALUES ($1,$2,$3,$4) RETURNING ${USER_SAFE_COLUMNS}`;
    const res = await pool.query(sql, [phone, name, hashed, role]);
    return res.rows[0];
}

export async function findUserByPhone(phone) {
    const res = await pool.query('SELECT * FROM users WHERE phone=$1', [phone]);
    return res.rows[0];
}

export async function findUserById(userId) {
    const res = await pool.query(`SELECT ${USER_SAFE_COLUMNS} FROM users WHERE id=$1`, [userId]);
    return res.rows[0];
}

export async function updateUserProfile(userId, updates) {
    const fields = [];
    const values = [];
    let idx = 1;

    if (updates.name !== undefined) {
        fields.push(`name=$${idx++}`);
        values.push(updates.name);
    }
    if (updates.email !== undefined) {
        fields.push(`email=$${idx++}`);
        values.push(updates.email);
    }
    if (updates.profilePhoto !== undefined) {
        fields.push(`profile_photo=$${idx++}`);
        values.push(updates.profilePhoto);
    }
    if (updates.gender !== undefined) {
        fields.push(`gender=$${idx++}`);
        values.push(updates.gender);
    }

    if (!fields.length) return null;

    values.push(userId);
    const sql = `UPDATE users SET ${fields.join(', ')} WHERE id=$${idx} RETURNING ${USER_SAFE_COLUMNS}`;
    const res = await pool.query(sql, values);
    return res.rows[0];
}

export async function requestOtp(phone) {
    const otp = generateOtp();
    const ttlSeconds = resolveOtpTtlSeconds();
    await redisClient.set(otpKey(phone), otp, { EX: ttlSeconds });
    return { otp, expiresIn: ttlSeconds };
}

export async function verifyOtp(phone, otp) {
    const key = otpKey(phone);
    const stored = await redisClient.get(key);
    if (!stored) return false;
    const storedBuf = Buffer.from(stored);
    const otpBuf = Buffer.from(otp);
    if (storedBuf.length !== otpBuf.length) return false;
    const matches = crypto.timingSafeEqual(storedBuf, otpBuf);
    if (!matches) return false;
    await redisClient.del(key);
    return true;
}

function signAccessToken(payload) {
    return jwt.sign(payload, JWT_SECRET, { expiresIn: ACCESS_EXPIRES });
}

function signRefreshToken() {
    // server-generated opaque token (safer than long JWT refresh)
    return uuidv4();
}

export async function issueTokens(user) {
    const accessToken = signAccessToken({ sub: user.id, role: user.role });
    const refreshToken = signRefreshToken();
    // store refresh token in redis keyed by token -> userId with expiry
    const key = `refresh:${refreshToken}`;
    await redisClient.set(key, user.id, { EX: REFRESH_DAYS * 24 * 60 * 60 });
    return { accessToken, refreshToken, expiresIn: ACCESS_EXPIRES };
}

export async function refreshAccessToken(refreshToken) {
    const key = `refresh:${refreshToken}`;
    const userId = await redisClient.get(key);
    if (!userId) throw new Error('Invalid refresh token');
    const res = await pool.query('SELECT id, role FROM users WHERE id=$1', [userId]);
    if (!res.rows[0]) throw new Error('User not found');
    const user = res.rows[0];
    // rotate refresh token: delete old, create new
    await redisClient.del(key);
    const newRefresh = signRefreshToken();
    await redisClient.set(`refresh:${newRefresh}`, user.id, { EX: REFRESH_DAYS * 24 * 60 * 60 });
    const newAccess = signAccessToken({ sub: user.id, role: user.role });
    return { accessToken: newAccess, refreshToken: newRefresh };
}

export async function revokeRefreshToken(refreshToken) {
    await redisClient.del(`refresh:${refreshToken}`);
}

export async function deleteUserById(userId) {
    const res = await pool.query('DELETE FROM users WHERE id=$1 RETURNING id', [userId]);
    return Boolean(res.rows[0]);
}
