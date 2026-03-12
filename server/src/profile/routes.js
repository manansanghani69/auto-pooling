import express from 'express';
import * as ctrl from './controller.js';
import { requireAuth } from '../common/authMiddleware.js';

const router = express.Router();

router.get('/', requireAuth, ctrl.profile);
router.patch('/', requireAuth, ctrl.updateProfile);
router.post('/rider/create-user', requireAuth, ctrl.createRiderUser);
router.post('/rider/edit-user', requireAuth, ctrl.editRiderUser);
router.patch('/rider/edit-user', requireAuth, ctrl.editRiderUser);
router.post('/driver/create-user', requireAuth, ctrl.createDriverUser);
router.post('/driver/edit-user', requireAuth, ctrl.editDriverUser);
router.patch('/driver/edit-user', requireAuth, ctrl.editDriverUser);
router.post('/driver/verify-document', requireAuth, ctrl.verifyDriverDocument);
router.patch('/driver/verify-document', requireAuth, ctrl.verifyDriverDocument);

export default router;
