import {z} from 'zod';
import * as requestTripService from './service.js';
import { normalizeRole } from '../common/userColumns.js';

const UPDATE_RIDE_REQUEST_SCHEMA = z
  .object({
    pickupLocation: z.string().trim().min(1, 'pickupLocation is required').max(255, 'pickupLocation is too long'),
    dropoffLocation: z.string().trim().min(1, 'dropoffLocation is required').max(255, 'dropoffLocation is too long'),
  })
  .strict();

const ACCEPT_RIDE_QUERY_SCHEMA = z
  .object({
    rideRequestId: z.string().uuid('rideRequestId must be a valid UUID'),
  })
  .strict();

function sendSuccess(res, status, data) {
  return res.status(status).json({
    status: 'success',
    code: status,
    data,
  });
}

function sendError(res, status, message, details) {
    return res.status(status).json({
        status: 'error',
        code: status,
        data: null,
        error: {
            message,
            ...(details ? { details } : {}),
        },
    });
}

function sendServerError(res, error) {
    console.error(error);
    return sendError(res, 500, 'server error');
}

function getAuthContext(req) {
    const userId = String(req.user?.sub ?? '').trim();
    const role = normalizeRole(req.user?.role);
    return { userId, role };
}

function formatValidationError(error) {
    return error.issues.map((issue) => ({
        field: issue.path.join('.') || 'body',
        message: issue.message,
    }));
}

function sendValidationError(res, error) {
    return sendError(res, 400, 'validation error', formatValidationError(error));
}

export async function requestRide(req, res) {
    try {
        const authContext = getAuthContext(req);
        if (authContext.role !== 'rider') {
            return sendError(res, 403, 'only riders can request rides');
        }
        const parseResult = UPDATE_RIDE_REQUEST_SCHEMA.safeParse(req.body);
        if (!parseResult.success) {
            return sendValidationError(res, parseResult.error);
        }
        const { pickupLocation, dropoffLocation } = parseResult.data;
        const rideRequest = await requestTripService.requestRide(authContext.userId, pickupLocation, dropoffLocation);
        return sendSuccess(res, 200, rideRequest);
    } catch (error) {
        return sendServerError(res, error);
    } 
}

export async function acceptRide(req, res) {
    try {
        const authContext = getAuthContext(req);
        if (authContext.role !== 'driver') {
            return sendError(res, 403, 'only drivers can accept rides');
        }
        const parseResult = ACCEPT_RIDE_QUERY_SCHEMA.safeParse(req.query);
        if (!parseResult.success) {
            return sendValidationError(res, parseResult.error);
        }
        const { rideRequestId } = parseResult.data;
        const ride = await requestTripService.acceptRide(authContext.userId, rideRequestId);
        if (!ride) {
            return sendError(res, 404, 'ride request not found or already accepted');
        }
        return sendSuccess(res, 200, ride);
    } catch (error) {
        return sendServerError(res, error);
    }
}