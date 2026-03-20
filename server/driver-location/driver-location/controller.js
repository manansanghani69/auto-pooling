import { z } from 'zod';
import * as driverLocationService from './service.js';
import { normalizeRole, USER_ROLES } from '../common/userColumns.js';

const UPDATE_DRIVER_LOCATION_SCHEMA = z
  .object({
    longitude: z.string().trim().min(1, 'longitude is required').max(255, 'longitude is too long'),
    latitude: z.string().trim().min(1, 'latitude is required').max(255, 'latitude is too long'),
  })
  .strict();

const DRIVER_ID_PARAMS_SCHEMA = z
  .object({
    driverId: z.string().uuid('driverId must be a valid UUID'),
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
  const driverId = String(req.user?.sub ?? '').trim();
  const role = normalizeRole(req.user?.role);
  return { driverId, role };
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

export async function updateDriverLocation(req, res) {
  try {
    const { driverId, role } = getAuthContext(req);
    if (!driverId || !role) return sendError(res, 401, 'unauthorized');
    if (role !== USER_ROLES.DRIVER) return sendError(res, 403, 'forbidden');

    const parsedBody = UPDATE_DRIVER_LOCATION_SCHEMA.safeParse(req.body ?? {});
    if (!parsedBody.success) return sendValidationError(res, parsedBody.error);

    const driverLocation = await driverLocationService.updateDriverLocation(
      driverId,
      parsedBody.data.longitude,
      parsedBody.data.latitude
    );
    return sendSuccess(res, 200, { driverLocation });
  } catch (error) {
    if (error?.code === '23503') return sendError(res, 404, 'driver not found');
    return sendServerError(res, error);
  }
}

// export async function getDriverLocation(req, res) {
//   try {
//     const authContext = getAuthContext(req);
//     if (!authContext.driverId || !authContext.role) return sendError(res, 401, 'unauthorized');

//     const parsedParams = DRIVER_ID_PARAMS_SCHEMA.safeParse(req.params ?? {});
//     if (!parsedParams.success) return sendValidationError(res, parsedParams.error);

//     const driverLocation = await driverLocationService.getDriverLocation(parsedParams.data.driverId);
//     if (!driverLocation) return sendError(res, 404, 'driver location not found');

//     return sendSuccess(res, 200, { driverLocation });
//   } catch (error) {
//     return sendServerError(res, error);
//   }
// }
