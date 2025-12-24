import express from 'express';
import dotenv from 'dotenv';
dotenv.config();
import authRoutes from './auth/routes.js';
import bodyParser from 'body-parser';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use('/v1/auth', authRoutes);

// health
app.get('/health', (req, res) => res.json({ ok: true }));

export default app;
