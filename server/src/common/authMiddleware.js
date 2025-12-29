import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
dotenv.config();

const JWT_SECRET = process.env.JWT_SECRET;

function sendAuthError(res, status, message) {
  return res.status(status).json({
    status: 'error',
    code: status,
    data: null,
    error: { message },
  });
}

export function requireAuth(req, res, next) {
  const auth = req.headers.authorization;
  if (!auth) return sendAuthError(res, 401, 'missing auth header');
  const parts = auth.split(' ');
  if (parts[0] !== 'Bearer' || !parts[1]) return sendAuthError(res, 401, 'invalid auth header');
  try {
    const payload = jwt.verify(parts[1], JWT_SECRET);
    req.user = payload;
    next();
  } catch (e) {
    return sendAuthError(res, 401, 'invalid token');
  }
}
