import http from 'http';
import dotenv from 'dotenv';
import httpProxy from 'http-proxy';
import { forwardApiRoute } from './api-routes.js';

dotenv.config({ path: new URL('./.env', import.meta.url), override: true });

const PORT = Number(process.env.PORT || 8080);
const AUTH_SERVICE_URL = process.env.AUTH_SERVICE_URL || 'http://localhost:4001';
const PROFILE_SERVICE_URL = process.env.PROFILE_SERVICE_URL || 'http://localhost:4002';
const DRIVER_LOCATION_SERVICE_URL = process.env.DRIVER_LOCATION_SERVICE_URL || 'http://localhost:4003';
const REQUEST_TRIP_SERVICE_URL = process.env.REQUEST_TRIP_SERVICE_URL || 'http://localhost:4004';
const NO_ROUTE_STATUS = 404;
const PROXY_ERROR_STATUS = 502;

const proxy = httpProxy.createProxyServer({
  changeOrigin: true,
  xfwd: true,
  ws: true,
});

function sendJson(res, statusCode, body) {
  res.writeHead(statusCode, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(body));
}

function parsePathname(url = '/') {
  return new URL(url, 'http://localhost').pathname;
}

function handleGatewayHealth(req, res) {
  if (parsePathname(req.url) !== '/health') return false;

  sendJson(res, 200, {
    status: 'success',
    code: 200,
    data: { ok: true, service: 'api-gateway' },
  });

  return true;
}

function handleNoRoute(res, pathname) {
  sendJson(res, NO_ROUTE_STATUS, {
    status: 'error',
    code: NO_ROUTE_STATUS,
    data: null,
    error: { message: `No gateway route configured for ${pathname}` },
  });
}

function handleProxyError(res) {
  sendJson(res, PROXY_ERROR_STATUS, {
    status: 'error',
    code: PROXY_ERROR_STATUS,
    data: null,
    error: { message: 'Upstream service unavailable' },
  });
}

proxy.on('error', (_, req, res) => {
  if (!res || res.headersSent) return;
  handleProxyError(res);
});

function forwardRequest(req, res, serviceUrl, rewrittenPath = null) {
  if (!rewrittenPath) return proxy.web(req, res, { target: serviceUrl });

  const search = new URL(req.url || '/', 'http://localhost').search;
  req.url = `${rewrittenPath}${search}`;
  return proxy.web(req, res, { target: serviceUrl });
}

function forwardHealthRoute(pathname, req, res) {
  const healthTargets = {
    '/v1/auth/health': AUTH_SERVICE_URL,
    '/v1/profile/health': PROFILE_SERVICE_URL,
    '/v1/driver-location/health': DRIVER_LOCATION_SERVICE_URL,
    '/v1/request-trip/health': REQUEST_TRIP_SERVICE_URL,
  };
  const target = healthTargets[pathname];
  if (!target) return false;
  forwardRequest(req, res, target, '/health');
  return true;
}

function handleHttpProxy(req, res) {
  const pathname = parsePathname(req.url);
  if (forwardHealthRoute(pathname, req, res)) return;
  if (
    forwardApiRoute({
      pathname,
      req,
      res,
      serviceUrls: {
        auth: AUTH_SERVICE_URL,
        profile: PROFILE_SERVICE_URL,
        driverLocation: DRIVER_LOCATION_SERVICE_URL,
      },
      forwardRequest,
    })
  ) {
    return;
  }
  return handleNoRoute(res, pathname);
}

const server = http.createServer((req, res) => {
  if (handleGatewayHealth(req, res)) return;
  return handleHttpProxy(req, res);
});

server.on('upgrade', (req, socket, head) => {
  const pathname = parsePathname(req.url);
  if (!pathname.startsWith('/ws/request-trip')) {
    socket.write('HTTP/1.1 404 Not Found\r\n\r\n');
    return socket.destroy();
  }

  return proxy.ws(req, socket, head, { target: REQUEST_TRIP_SERVICE_URL });
});

server.listen(PORT, () => {
  console.log(`api-gateway service running on ${PORT}`);
});
