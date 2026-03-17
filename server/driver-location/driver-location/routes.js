import express from 'express';
import * as controller from './controller.js';
import { requireAuth } from '../common/authMiddleware.js';

const router = express.Router();

router.patch('/', requireAuth, controller.updateDriverLocation);
router.get('/:driverId', requireAuth, controller.getDriverLocation);

export default router;
