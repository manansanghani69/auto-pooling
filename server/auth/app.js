import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import authRoutes from './auth/routes.js';

dotenv.config({ path: new URL('./.env', import.meta.url), override: true });

const app = express();

app.use(cors());
app.use(express.json());
app.use('/v1/auth', authRoutes);

app.get('/health', (req, res) =>
  res.status(200).json({
    status: 'success',
    code: 200,
    data: { ok: true, service: 'auth' },
  })
);

export default app;
