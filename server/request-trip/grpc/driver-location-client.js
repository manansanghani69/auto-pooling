import grpc from '@grpc/grpc-js';
import { getDriverLocationClientConstructor } from './nearby-drivers-proto.js';

const DEFAULT_DRIVER_LOCATION_GRPC_ADDRESS = '127.0.0.1:50051';
const DEFAULT_NEARBY_DRIVERS_RADIUS_KM = '5';

function getDriverLocationGrpcAddress() {
  return String(
    process.env.DRIVER_LOCATION_GRPC_ADDRESS ||
      process.env.DRIVER_LOCATION_GRPC_URL ||
      DEFAULT_DRIVER_LOCATION_GRPC_ADDRESS
  ).trim();
}

function getNearbyDriversRadius() {
  const configuredRadius = String(
    process.env.NEARBY_DRIVERS_RADIUS_KM || DEFAULT_NEARBY_DRIVERS_RADIUS_KM
  ).trim();

  if (configuredRadius.length > 0 && Number.isFinite(Number(configuredRadius)) && Number(configuredRadius) > 0) {
    return configuredRadius;
  }

  return DEFAULT_NEARBY_DRIVERS_RADIUS_KM;
}

function createDriverLocationUnavailableError(error) {
  const serviceError = new Error('driver-location service unavailable');
  serviceError.code = 'DRIVER_LOCATION_UNAVAILABLE';
  serviceError.cause = error;
  return serviceError;
}

function mapNearbyDriver(driver) {
  return {
    driverId: driver.driverId,
    longitude: driver.longitute,
    latitude: driver.latitude,
  };
}

function getDriverLocationClient() {
  const DriverLocationClient = getDriverLocationClientConstructor();
  return new DriverLocationClient(
    getDriverLocationGrpcAddress(),
    grpc.credentials.createInsecure()
  );
}

export function findNearbyDrivers(pickupLocation) {
  const client = getDriverLocationClient();
  const request = {
    pickUpLongitude: pickupLocation.longitude,
    pickUpLatitude: pickupLocation.latitude,
    radius: getNearbyDriversRadius(),
  };

  return new Promise((resolve, reject) => {
    client.FindNearByDrivers(request, (error, response) => {
      client.close();

      if (error) return reject(createDriverLocationUnavailableError(error));
      return resolve((response?.drivers ?? []).map(mapNearbyDriver));
    });
  });
}
