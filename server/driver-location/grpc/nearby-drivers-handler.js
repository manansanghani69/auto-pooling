import grpc from '@grpc/grpc-js';
import { z } from 'zod';
import * as driverLocationService from '../driver-location/service.js';

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

const USER_LOCATION_SCHEMA = z
  .object({
    pickUpLongitude: createCoordinateSchema('pickUpLongitude', -180, 180),
    pickUpLatitude: createCoordinateSchema('pickUpLatitude', -90, 90),
    radius: z
      .string()
      .trim()
      .min(1, 'radius is required')
      .refine(isFiniteNumberString, 'radius must be a valid number')
      .refine((value) => Number(value) > 0, 'radius must be greater than 0'),
  })
  .strict();

function formatValidationIssues(error) {
  return error.issues.map((issue) => `${issue.path.join('.') || 'request'}: ${issue.message}`);
}

function createValidationError(error) {
  const validationError = new Error('validation error');
  validationError.code = grpc.status.INVALID_ARGUMENT;
  validationError.details = formatValidationIssues(error).join('; ');
  return validationError;
}

function createInternalError(error) {
  console.error('FindNearByDrivers failed', error);

  const internalError = new Error('internal server error');
  internalError.code = grpc.status.INTERNAL;
  return internalError;
}

function mapNearbyDriver(driver) {
  return {
    driverId: driver.driverId,
    longitute: driver.longitude,
    latitude: driver.latitude,
  };
}

function validateUserLocation(payload) {
  return USER_LOCATION_SCHEMA.parse(payload ?? {});
}

export async function findNearByDrivers(call, callback) {
  try {
    const { pickUpLongitude, pickUpLatitude, radius } = validateUserLocation(call.request);
    const nearbyDrivers = await driverLocationService.getNearbyDrivers(
      pickUpLongitude,
      pickUpLatitude,
      radius
    );

    return callback(null, { drivers: nearbyDrivers.map(mapNearbyDriver) });
  } catch (error) {
    if (error instanceof z.ZodError) return callback(createValidationError(error));
    return callback(createInternalError(error));
  }
}
