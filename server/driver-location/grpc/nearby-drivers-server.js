import grpc from '@grpc/grpc-js';
import { findNearByDrivers } from './nearby-drivers-handler.js';
import { getDriverLocationGrpcService } from './nearby-drivers-proto.js';

const DEFAULT_GRPC_PORT = 50051;

function getGrpcPort() {
  const configuredPort = Number(process.env.DRIVER_LOCATION_GRPC_PORT || process.env.GRPC_PORT);
  if (Number.isInteger(configuredPort) && configuredPort > 0) return configuredPort;
  return DEFAULT_GRPC_PORT;
}

function createGrpcServer() {
  const server = new grpc.Server();
  const driverLocationService = getDriverLocationGrpcService();

  server.addService(driverLocationService.service, {
    FindNearByDrivers: findNearByDrivers,
  });

  return server;
}

function bindGrpcServer(server, address) {
  return new Promise((resolve, reject) => {
    server.bindAsync(address, grpc.ServerCredentials.createInsecure(), (error, port) => {
      if (error) return reject(error);
      return resolve(port);
    });
  });
}

export async function startGrpcServer() {
  const port = getGrpcPort();
  const address = `0.0.0.0:${port}`;
  const server = createGrpcServer();
  const boundPort = await bindGrpcServer(server, address);

  return { server, port: boundPort };
}
