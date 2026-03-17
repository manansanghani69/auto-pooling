import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import driverLocationRoutes from './driver-location/routes.js';

dotenv.config({ path: new URL('./.env', import.meta.url), override: true });

const app = express();

app.use(cors());
app.use(express.json());
app.use('/v1/driver-location', driverLocationRoutes);

app.get('/health', (req, res) =>
  res.status(200).json({
    status: 'success',
    code: 200,
    data: { ok: true, service: 'driver-location' },
  })
);

export default app;
