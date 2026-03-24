import path from 'node:path';
import { fileURLToPath } from 'node:url';
import grpc from '@grpc/grpc-js';
import protoLoader from '@grpc/proto-loader';

const currentDirectory = path.dirname(fileURLToPath(import.meta.url));
const PROTO_PATH = path.resolve(currentDirectory, '../../driver-location/protos/nearby_drivers.proto');
const PROTO_LOADER_OPTIONS = {
  keepCase: true,
  longs: String,
  enums: String,
  defaults: true,
  oneofs: true,
};

function loadDriverLocationPackage() {
  const packageDefinition = protoLoader.loadSync(PROTO_PATH, PROTO_LOADER_OPTIONS);
  return grpc.loadPackageDefinition(packageDefinition);
}

export function getDriverLocationClientConstructor() {
  const grpcPackage = loadDriverLocationPackage();
  const driverLocationPackage = grpcPackage.DriverLocation;
  const driverLocationClient = driverLocationPackage?.DriverLocation;

  if (typeof driverLocationClient !== 'function') {
    throw new Error('DriverLocation gRPC client definition is invalid');
  }

  return driverLocationClient;
}
