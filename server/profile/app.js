import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import profileRoutes from './profile/routes.js';

dotenv.config({ path: new URL('./.env', import.meta.url), override: true });

const app = express();

app.use(cors());
app.use(express.json());
app.use('/v1/profile', profileRoutes);

app.get('/health', (req, res) =>
  res.status(200).json({
    status: 'success',
    code: 200,
    data: { ok: true, service: 'profile' },
  })
);

export default app;
