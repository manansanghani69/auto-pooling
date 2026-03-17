import express from 'express';
import * as controller from './controller.js';
import { requireAuth } from '../common/authMiddleware.js';

const router = express.Router();

router.get('/', requireAuth, controller.profile);
router.patch('/', requireAuth, controller.updateProfile);
router.post('/rider/create-user', requireAuth, controller.createRiderUser);
router.post('/rider/edit-user', requireAuth, controller.editRiderUser);
router.patch('/rider/edit-user', requireAuth, controller.editRiderUser);
router.post('/driver/create-user', requireAuth, controller.createDriverUser);
router.post('/driver/edit-user', requireAuth, controller.editDriverUser);
router.patch('/driver/edit-user', requireAuth, controller.editDriverUser);
router.post('/driver/verify-document', requireAuth, controller.verifyDriverDocument);
router.patch('/driver/verify-document', requireAuth, controller.verifyDriverDocument);

export default router;
