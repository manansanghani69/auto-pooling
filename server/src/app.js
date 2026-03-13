import express from 'express';
import dotenv from 'dotenv';
dotenv.config();
import authRoutes from './auth/routes.js';
import profileRoutes from './profile/routes.js';
import bodyParser from 'body-parser';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use('/v1/auth', authRoutes);
app.use('/v1/profile', profileRoutes);

// health
app.get('/health', (req, res) => res.status(200).json({
  status: 'success',
  code: 200,
  data: { ok: true },
}));

export default app;
