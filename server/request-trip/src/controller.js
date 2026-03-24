import { z } from 'zod';
import * as requestTripService from './service.js';
import { normalizeRole } from '../common/userColumns.js';

function isFiniteNumberString(value) {
  return Number.isFinite(Number(value));
}

function isNumberStringInRange(value, minimum, maximum) {
  const numericValue = Number(value);
  return numericValue >= minimum && numericValue <= maximum;
}

function createCoordinateSchema(fieldName, minimum, maximum) {
  return z
    .string()
    .trim()
    .min(1, `${fieldName} is required`)
    .refine(isFiniteNumberString, `${fieldName} must be a valid number`)
    .refine(
      (value) => isNumberStringInRange(value, minimum, maximum),
      `${fieldName} is out of range`
    );
}

const UPDATE_RIDE_REQUEST_SCHEMA = z
  .object({
    pickupLongitude: createCoordinateSchema('pickupLongitude', -180, 180),
    pickupLatitude: createCoordinateSchema('pickupLatitude', -90, 90),
    dropoffLongitude: createCoordinateSchema('dropoffLongitude', -180, 180),
    dropoffLatitude: createCoordinateSchema('dropoffLatitude', -90, 90),
  })
  .strict();

const ACCEPT_RIDE_QUERY_SCHEMA = z
  .object({
    rideRequestId: z.uuid('rideRequestId must be a valid UUID'),
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
    if (error?.code === 'DRIVER_LOCATION_UNAVAILABLE') {
        return sendError(res, 503, 'driver-location service unavailable');
    }
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
        const { pickupLongitude, pickupLatitude, dropoffLongitude, dropoffLatitude } = parseResult.data;
        const rideRequest = await requestTripService.requestRide({
            userId: authContext.userId,
            pickupLocation: { longitude: pickupLongitude, latitude: pickupLatitude },
            dropoffLocation: { longitude: dropoffLongitude, latitude: dropoffLatitude },
        });
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
