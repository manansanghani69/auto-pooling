import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';

dotenv.config({ path: new URL('../.env', import.meta.url), override: true });

const { JWT_SECRET } = process.env;

if (!JWT_SECRET) {
  throw new Error('JWT_SECRET environment variable is required');
}

export function parseBearerToken(authHeader) {
  const parts = String(authHeader ?? '').trim().split(' ');
  if (parts[0] !== 'Bearer' || !parts[1]) return null;
  return parts[1];
}

export function verifyAccessToken(token) {
  return jwt.verify(token, JWT_SECRET);
}

export function getWebSocketAccessToken(request) {
  const requestUrl = new URL(request.url ?? '/', 'ws://localhost');
  const queryToken = requestUrl.searchParams.get('token');

  if (queryToken?.trim()) return queryToken.trim();
  return parseBearerToken(request.headers.authorization);
}
