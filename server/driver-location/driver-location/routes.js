import express from 'express';
import * as controller from './controller.js';
import { requireAuth } from '../common/authMiddleware.js';

const router = express.Router();

router.patch('/', requireAuth, controller.updateDriverLocation);
// router.post('/activate', requireAuth, controller.activateDriver);
// router.post('/deactivate', requireAuth, controller.deactivateDriver);

export default router;
