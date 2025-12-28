import express from 'express';
import * as ctrl from './controller.js';
import { requireAuth } from './middleware.js';

const router = express.Router();

router.post('/request-otp', ctrl.requestOtp);
router.post('/verify-otp', ctrl.verifyOtp);
router.post('/refresh', ctrl.refresh);
router.post('/logout', ctrl.logout);
router.delete('/delete/user', requireAuth, ctrl.deleteAccount);
// Only to test auth tokens
router.get('/profile', requireAuth, ctrl.profile);

export default router;
