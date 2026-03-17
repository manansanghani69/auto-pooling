import express from 'express';
import * as controller from './controller.js';
import { requireAuth } from '../common/authMiddleware.js';

const router = express.Router();

router.post('/request-otp', controller.requestOtp);
router.post('/verify-otp', controller.verifyOtp);
router.post('/refresh', controller.refresh);
router.post('/logout', controller.logout);
router.delete('/delete/user', requireAuth, controller.deleteAccount);

export default router;
