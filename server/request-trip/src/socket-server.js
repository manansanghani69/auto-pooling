import { randomUUID } from 'crypto';
import { z } from 'zod';
import { WebSocket, WebSocketServer } from 'ws';
import { getWebSocketAccessToken, verifyAccessToken } from '../common/auth.js';
import { normalizeRole } from '../common/userColumns.js';
import * as requestTripService from './service.js';

const SOCKET_PATH = '/ws/request-trip';
const SOCKET_MESSAGE_SCHEMA = z
  .object({
    event: z.enum(['trip.request', 'trip.accept']),
    requestId: z.string().trim().min(1).max(100).optional(),
    data: z.unknown(),
  })
  .strict();

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
    .refine((value) => isNumberStringInRange(value, minimum, maximum), `${fieldName} is out of range`);
}

const REQUEST_RIDE_SCHEMA = z
  .object({
    pickupLongitude: createCoordinateSchema('pickupLongitude', -180, 180),
    pickupLatitude: createCoordinateSchema('pickupLatitude', -90, 90),
    dropoffLongitude: createCoordinateSchema('dropoffLongitude', -180, 180),
    dropoffLatitude: createCoordinateSchema('dropoffLatitude', -90, 90),
  })
  .strict();

const ACCEPT_RIDE_SCHEMA = z
  .object({
    tripRequestId: z.uuid('tripRequestId must be a valid UUID'),
  })
  .strict();


//will have to setup another connection to redis pub/sub to store socketid of active users.
function createConnectionRegistry() {
  return new Map();
}

function getRequestId(message) {
  return message.requestId ?? randomUUID();
}

function formatValidationDetails(error) {
  return error.issues.map((issue) => ({
    field: issue.path.join('.') || 'data',
    message: issue.message,
  }));
}

function sendMessage(socket, payload) {
  if (socket.readyState !== WebSocket.OPEN) return;
  socket.send(JSON.stringify(payload));
}

function sendError(socket, requestId, code, message, details) {
  sendMessage(socket, {
    event: 'error',
    error: {
      code,
      message,
      ...(details ? { details } : {}),
    },
    meta: { requestId },
  });
}

function registerConnection(registry, userId, socket) {
  const userSockets = registry.get(userId) ?? new Set();
  userSockets.add(socket);
  registry.set(userId, userSockets);
}

function unregisterConnection(registry, userId, socket) {
  const userSockets = registry.get(userId);
  if (!userSockets) return;

  userSockets.delete(socket);
  if (userSockets.size === 0) registry.delete(userId);
}

function authenticateConnection(request) {
  const token = getWebSocketAccessToken(request);
  if (!token) return null;

  try {
    const claims = verifyAccessToken(token);
    const userId = String(claims?.sub ?? '').trim();
    const role = normalizeRole(claims?.role);
    if (!userId || !role) return null;
    return { userId, role };
  } catch {
    return null;
  }
}

function parseClientMessage(rawMessage) {
  return SOCKET_MESSAGE_SCHEMA.parse(JSON.parse(rawMessage));
}

function buildRideRequestPayload(payload) {
  const parsedPayload = REQUEST_RIDE_SCHEMA.parse(payload);

  return {
    pickupLocation: {
      longitude: parsedPayload.pickupLongitude,
      latitude: parsedPayload.pickupLatitude,
    },
    dropoffLocation: {
      longitude: parsedPayload.dropoffLongitude,
      latitude: parsedPayload.dropoffLatitude,
    },
  };
}

function addLifecycleHandlers(socket, registry, authContext) {
  socket.on('close', () => unregisterConnection(registry, authContext.userId, socket));
  socket.on('error', (error) => console.error('request-trip websocket error', error));
}

function notifyUserConnections(registry, userId, payload) {
  const userSockets = registry.get(userId);
  if (!userSockets) return;
  userSockets.forEach((socket) => sendMessage(socket, payload));
}

function buildDriverTripAvailableEvent(requestedTrip) {
  return {
    event: 'trip.request.available',
    data: {
      tripRequestId: requestedTrip.tripRequestId,
      pickupLocation: requestedTrip.pickupLocation,
      dropoffLocation: requestedTrip.dropoffLocation,
      status: requestedTrip.status,
      requestedAt: requestedTrip.requestedAt,
    },
    meta: { requestId: randomUUID() },
  };
}

function notifyNearbyDrivers(registry, requestedTrip) {
  requestedTrip.nearbyDrivers.forEach((driver) => {
    notifyUserConnections(registry, driver.driverId, buildDriverTripAvailableEvent(requestedTrip));
  });
}

function notifyRiderTripAccepted(registry, activeTrip) {
  notifyUserConnections(registry, activeTrip.riderId, {
    event: 'trip.accepted',
    data: activeTrip,
    meta: { requestId: randomUUID() },
  });
}

async function handleTripRequest(socket, registry, authContext, requestId, data) {
  if (authContext.role !== 'rider') {
    sendError(socket, requestId, 'FORBIDDEN', 'only riders can request rides');
    return;
  }

  const ridePayload = buildRideRequestPayload(data);
  const requestedTrip = await requestTripService.requestRide({
    userId: authContext.userId,
    ...ridePayload,
  });

  sendMessage(socket, {
    event: 'trip.requested',
    data: {
      tripRequestId: requestedTrip.tripRequestId,
      nearbyDriverCount: requestedTrip.nearbyDrivers.length,
      status: requestedTrip.status,
    },
    meta: { requestId },
  });

  notifyNearbyDrivers(registry, requestedTrip);
}

async function handleTripAccept(socket, registry, authContext, requestId, data) {
  if (authContext.role !== 'driver') {
    sendError(socket, requestId, 'FORBIDDEN', 'only drivers can accept rides');
    return;
  }

  const { tripRequestId } = ACCEPT_RIDE_SCHEMA.parse(data);
  const activeTrip = await requestTripService.acceptRide({
    driverId: authContext.userId,
    tripRequestId,
  });

  if (!activeTrip) {
    sendError(socket, requestId, 'TRIP_NOT_AVAILABLE', 'trip request not found or already accepted');
    return;
  }

  sendMessage(socket, {
    event: 'trip.accepted',
    data: activeTrip,
    meta: { requestId },
  });

  notifyRiderTripAccepted(registry, activeTrip);
}

async function handleClientMessage(socket, registry, authContext, rawMessage) {
  let requestId = randomUUID();

  try {
    const message = parseClientMessage(rawMessage);
    requestId = getRequestId(message);

    if (message.event === 'trip.request') {
      await handleTripRequest(socket, registry, authContext, requestId, message.data);
      return;
    }

    await handleTripAccept(socket, registry, authContext, requestId, message.data);
  } catch (error) {
    if (error instanceof SyntaxError) {
      sendError(socket, requestId, 'INVALID_JSON', 'message must be valid JSON');
      return;
    }

    if (error instanceof z.ZodError) {
      sendError(socket, requestId, 'VALIDATION_ERROR', 'validation error', formatValidationDetails(error));
      return;
    } 

    if (error?.code === 'DRIVER_LOCATION_UNAVAILABLE') {
      sendError(socket, requestId, 'DRIVER_LOCATION_UNAVAILABLE', 'driver-location service unavailable');
      return;
    }

    console.error('request-trip websocket handler failed', error);
    sendError(socket, requestId, 'INTERNAL_SERVER_ERROR', 'server error');
  }
}

function handleConnection(socket, request, registry) {
  const authContext = authenticateConnection(request);
  if (!authContext) {
    socket.close(4401, 'Unauthorized');
    return;
  }

  registerConnection(registry, authContext.userId, socket);
  addLifecycleHandlers(socket, registry, authContext);

  sendMessage(socket, {
    event: 'connection.ready',
    data: {
      userId: authContext.userId,
      role: authContext.role,
      path: SOCKET_PATH,
    },
    meta: { requestId: randomUUID() },
  });

  socket.on('message', async (messageBuffer) => {
    await handleClientMessage(socket, registry, authContext, messageBuffer.toString());
  });
}

export function attachRequestTripSocketServer(server) {
  const connectionRegistry = createConnectionRegistry();
  const webSocketServer = new WebSocketServer({ server, path: SOCKET_PATH });

  webSocketServer.on('connection', (socket, request) => {
    handleConnection(socket, request, connectionRegistry);
  });

  return webSocketServer;
}
