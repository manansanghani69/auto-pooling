import path from 'node:path';
import { fileURLToPath } from 'node:url';
import grpc from '@grpc/grpc-js';
import protoLoader from '@grpc/proto-loader';

const currentDirectory = path.dirname(fileURLToPath(import.meta.url));
const PROTO_PATH = path.resolve(currentDirectory, '../protos/nearby_drivers.proto');
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

export function getDriverLocationGrpcService() {
  const grpcPackage = loadDriverLocationPackage();
  const driverLocationPackage = grpcPackage.DriverLocation;
  const driverLocationService = driverLocationPackage?.DriverLocation;

  if (!driverLocationService?.service) {
    throw new Error('DriverLocation gRPC service definition is invalid');
  }

  return driverLocationService;
}
