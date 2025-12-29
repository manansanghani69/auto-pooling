import express from 'express';
import * as ctrl from './controller.js';
import { requireAuth } from '../common/authMiddleware.js';

const router = express.Router();

router.get('/', requireAuth, ctrl.profile);
router.patch('/', requireAuth, ctrl.updateProfile);

export default router;
