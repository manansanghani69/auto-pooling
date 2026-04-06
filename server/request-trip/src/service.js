import { randomUUID } from 'crypto';
import dotenv from 'dotenv';
import { redisClient } from '../common/redis.js';
import { findNearbyDrivers } from '../grpc/driver-location-client.js';

dotenv.config({ path: new URL('../.env', import.meta.url), override: true });

const RIDE_REQUEST_CHANNEL = 'ride-requests';
const DEFAULT_TTL_SECONDS = 300;
const RIDE_REQUEST_TTL_SECONDS = Number(process.env.RIDE_REQUEST_TTL_SECONDS || DEFAULT_TTL_SECONDS);
const TRIP_CACHE_KEY_PREFIX = Object.freeze({
  REQUESTED: 'trip:requested',
  ACTIVE: 'trip:active',
  CANCEL: 'trip:cancel',
});

function getTripStateCacheKey(prefix, tripRequestId) {
  return `${prefix}:${tripRequestId}`;
}

function getRideRequestTtlSeconds() {
  if (Number.isInteger(RIDE_REQUEST_TTL_SECONDS) && RIDE_REQUEST_TTL_SECONDS > 0) {
    return RIDE_REQUEST_TTL_SECONDS;
  }
  return DEFAULT_TTL_SECONDS;
}

function parseCachedTripValue(cachedValue) {
  if (!cachedValue) return null;

  try {
    const parsed = JSON.parse(cachedValue);
    if (parsed && typeof parsed.trip === 'object') return parsed.trip;
  } catch {
    return null;
  }

  return null;
}

async function getCachedTrip(prefix, tripRequestId) {
  const key = getTripStateCacheKey(prefix, tripRequestId);

  try {
    const cachedValue = await redisClient.get(key);
    return parseCachedTripValue(cachedValue);
  } catch (error) {
    console.error('trip cache read failed', error);
    return null;
  }
}

async function setCachedTrip(prefix, tripRequestId, trip, ttlSeconds = getRideRequestTtlSeconds()) {
  const key = getTripStateCacheKey(prefix, tripRequestId);
  const payload = JSON.stringify({ trip });

  try {
    await redisClient.set(key, payload, 'EX', ttlSeconds);
  } catch (error) {
    console.error('trip cache write failed', error);
  }
}

function buildRequestedTrip({ tripRequestId, riderId, pickupLocation, dropoffLocation, nearbyDrivers }) {
  return {
    tripRequestId,
    riderId,
    pickupLocation,
    dropoffLocation,
    nearbyDrivers,
    status: 'requested',
    requestedAt: new Date().toISOString(),
  };
}

function buildActiveTrip(requestedTrip, driverId) {
  return {
    tripRequestId: requestedTrip.tripRequestId,
    riderId: requestedTrip.riderId,
    driverId,
    pickupLocation: requestedTrip.pickupLocation,
    dropoffLocation: requestedTrip.dropoffLocation,
    status: 'active',
    requestedAt: requestedTrip.requestedAt,
    acceptedAt: new Date().toISOString(),
  };
}

function getRequestedTripKey(tripRequestId) {
  return getTripStateCacheKey(TRIP_CACHE_KEY_PREFIX.REQUESTED, tripRequestId);
}

function getActiveTripKey(tripRequestId) {
  return getTripStateCacheKey(TRIP_CACHE_KEY_PREFIX.ACTIVE, tripRequestId);
}

export function getCancelledTripKey(tripRequestId) {
  return getTripStateCacheKey(TRIP_CACHE_KEY_PREFIX.CANCEL, tripRequestId);
}

function getRedisTtl(ttlSeconds) {
  if (ttlSeconds > 0) return ttlSeconds;
  return getRideRequestTtlSeconds();
}

function isDriverEligible(requestedTrip, driverId) {
  return requestedTrip.nearbyDrivers.some((driver) => driver.driverId === driverId);
}

export async function requestRide({ userId, pickupLocation, dropoffLocation }) {
  const tripRequestId = randomUUID();
  const nearbyDrivers = await findNearbyDrivers(pickupLocation);
  const requestedTrip = buildRequestedTrip({
    tripRequestId,
    riderId: userId,
    pickupLocation,
    dropoffLocation,
    nearbyDrivers,
  });

  await setCachedTrip(TRIP_CACHE_KEY_PREFIX.REQUESTED, tripRequestId, requestedTrip);
  await publishRideRequest(requestedTrip);

  return requestedTrip;
}

export async function acceptRide({ driverId, tripRequestId }) {
  const requestedTripKey = getRequestedTripKey(tripRequestId);
  const activeTripKey = getActiveTripKey(tripRequestId);

  await redisClient.watch(requestedTripKey);

  try {
    const requestedTrip = await getCachedTrip(TRIP_CACHE_KEY_PREFIX.REQUESTED, tripRequestId);
    if (!requestedTrip || !isDriverEligible(requestedTrip, driverId)) {
      await redisClient.unwatch();
      return null;
    }

    const requestedTripTtlSeconds = await redisClient.ttl(requestedTripKey);
    const activeTrip = buildActiveTrip(requestedTrip, driverId);
    const payload = JSON.stringify({ trip: activeTrip });
    const ttlSeconds = getRedisTtl(requestedTripTtlSeconds);
    const transactionResult = await redisClient
      .multi()
      .set(activeTripKey, payload, 'EX', ttlSeconds)
      .del(requestedTripKey)
      .exec();

    if (transactionResult === null) return null;
    return activeTrip;
  } catch (error) {
    await redisClient.unwatch();
    throw error;
  }
}

export async function publishRideRequest(request) {
  try {
    await redisClient.publish(RIDE_REQUEST_CHANNEL, JSON.stringify(request));
  } catch (error) {
    console.error('Failed to publish ride request', error);
  }
}
