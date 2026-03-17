import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';

dotenv.config({ path: new URL('../.env', import.meta.url), override: true });

if (!process.env.JWT_SECRET) {
  throw new Error('JWT_SECRET environment variable is required');
}

function sendAuthError(res, status, message) {
  return res.status(status).json({
    status: 'error',
    code: status,
    data: null,
    error: { message },
  });
}

export function requireAuth(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader) return sendAuthError(res, 401, 'missing auth header');

  const parts = authHeader.split(' ');
  if (parts[0] !== 'Bearer' || !parts[1]) {
    return sendAuthError(res, 401, 'invalid auth header');
  }

  try {
    req.user = jwt.verify(parts[1], process.env.JWT_SECRET);
    next();
  } catch {
    return sendAuthError(res, 401, 'invalid token');
  }
}
