// src/auth/service.js
import bcrypt from 'bcrypt';
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

export async function createUser({ phone, name, password, role = 'rider' }) {
    const hashed = await bcrypt.hash(password, SALT_ROUNDS);
    const sql = `INSERT INTO users (phone, name, password, role) VALUES ($1,$2,$3,$4) RETURNING id, phone, name, role, created_at`;
    const res = await pool.query(sql, [phone, name, hashed, role]);
    return res.rows[0];
}

export async function findUserByPhone(phone) {
    const res = await pool.query('SELECT * FROM users WHERE phone=$1', [phone]);
    return res.rows[0];
}

export async function verifyPassword(plain, hashed) {
    return bcrypt.compare(plain, hashed);
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
