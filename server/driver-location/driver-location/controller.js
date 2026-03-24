import { z } from 'zod';
import * as driverLocationService from './service.js';
import { normalizeRole, USER_ROLES } from '../common/userColumns.js';

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

const UPDATE_DRIVER_LOCATION_SCHEMA = z
  .object({
    longitude: createCoordinateSchema('longitude', -180, 180),
    latitude: createCoordinateSchema('latitude', -90, 90),
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
