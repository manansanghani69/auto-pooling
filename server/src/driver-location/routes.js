import express from 'express';
import * as driverLocationController from './controlller.js';
import { requireAuth } from '../common/authMiddleware.js';

const router = express.Router();

router.patch('/', requireAuth, driverLocationController.updateDriverLocation);
router.get('/:driverId', requireAuth, driverLocationController.getDriverLocation);

export default router;
