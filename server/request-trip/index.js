import dotenv from 'dotenv';
import http from 'http';
import app from './app.js';
import { attachRequestTripSocketServer } from './src/socket-server.js';

dotenv.config({ path: new URL('./.env', import.meta.url), override: true });

const PORT = Number(process.env.PORT || 4004);
const server = http.createServer(app);

attachRequestTripSocketServer(server);

server.listen(PORT, () => {
  console.log(`request-trip service running on ${PORT}`);
});
