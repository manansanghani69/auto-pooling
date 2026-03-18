import express from 'express';
import * as controller from './controller.js';
import { requireAuth } from '../common/authMiddleware.js';

const router = express.Router();

router.patch('/rider/request-ride', requireAuth, controller.requestRide);
router.get('/driver/accept-ride', requireAuth, controller.acceptRide);

export default router;