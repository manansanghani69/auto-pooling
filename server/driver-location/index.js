import dotenv from 'dotenv';
import app from './app.js';
import { startGrpcServer } from './grpc/nearby-drivers-server.js';

dotenv.config({ path: new URL('./.env', import.meta.url), override: true });

const HTTP_PORT = Number(process.env.PORT || 4003);

function startHttpServer(port) {
  return new Promise((resolve, reject) => {
    const server = app.listen(port, () => resolve(server));
    server.on('error', reject);
  });
}

function stopHttpServer(server) {
  return new Promise((resolve, reject) => {
    server.close((error) => {
      if (error) return reject(error);
      return resolve();
    });
  });
}

async function bootstrap() {
  const httpServer = await startHttpServer(HTTP_PORT);

  try {
    const { port: grpcPort } = await startGrpcServer();
    console.log(`driver-location HTTP service running on ${HTTP_PORT}`);
    console.log(`driver-location gRPC service running on ${grpcPort}`);
  } catch (error) {
    await stopHttpServer(httpServer);
    throw error;
  }
}

bootstrap().catch((error) => {
  console.error('driver-location bootstrap failed', error);
  process.exit(1);
});
