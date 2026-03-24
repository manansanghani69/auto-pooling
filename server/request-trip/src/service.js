import dotenv from 'dotenv';
import { redisClient } from '../common/redis.js';
import { findNearbyDrivers } from '../grpc/driver-location-client.js';

dotenv.config({ path: new URL('../.env', import.meta.url), override: true });

const RIDE_REQUEST_CHANNEL = 'ride-requests';
const RIDE_REQUEST_TTL_SECONDS = Number(process.env.RIDE_REQUEST_TTL_SECONDS || 300);

function getTripRequestCacheKey(tripRequestId) {
    return `${RIDE_REQUEST_TTL_SECONDS}:${tripRequestId}`;
}

function getRideRequestTtlSeconds() {
    if (Number.isInteger(RIDE_REQUEST_TTL_SECONDS) && RIDE_REQUEST_TTL_SECONDS > 0) {
        return RIDE_REQUEST_TTL_SECONDS;
    }
    return 300;
}

function parseCachedRideRequestValue(cachedValue) {
    if (!cachedValue) return null;
    try {
        const parsed = JSON.parse(cachedValue);
        if (parsed && typeof parsed.request === 'object') return parsed.request;
    } catch {
        return null;
    }
}

async function getCachedRideRequest(tripRequestId) {
    const key = getTripRequestCacheKey(tripRequestId);
    try {
        const cachedValue = await redisClient.get(key);
        const request = parseCachedRideRequestValue(cachedValue);
        if (!request) return null;
        return { tripRequestId, request, source: 'cache' };
    } catch (error) {
        console.error('ride request cache read failed', error);
        return null;
    }
}

async function setCachedRideRequest(tripRequestId, request) {
    const key = getTripRequestCacheKey(tripRequestId);
    const payload = JSON.stringify({ request });
    const ttlSeconds = getRideRequestTtlSeconds();
    try {
        await redisClient.set(key, payload, 'EX', ttlSeconds);
    } catch (error) {
        console.error('ride request cache write failed', error);
    }
}

function buildRideRequest({
    tripRequestId,
    userId,
    pickupLocation,
    dropoffLocation,
    nearbyDrivers,
}) {
    return {
        tripRequestId,
        userId,
        pickupLocation,
        dropoffLocation,
        nearbyDrivers,
        status: 'pending',
    };
}

export async function requestRide({ userId, pickupLocation, dropoffLocation }) {
    const tripRequestId = `trip-${Date.now()}-${Math.random().toString(36).substring(2, 8)}`;
    const nearbyDrivers = await findNearbyDrivers(pickupLocation);
    const request = buildRideRequest({
        tripRequestId,
        userId,
        pickupLocation,
        dropoffLocation,
        nearbyDrivers,
    });

    await setCachedRideRequest(tripRequestId, request);
    // await publishRideRequest(request);

    return { tripRequestId };
}

export async function publishRideRequest(request) {
    try {
        await redisClient.publish(RIDE_REQUEST_CHANNEL, JSON.stringify(request));
    } catch (error) {
        console.error('Failed to publish ride request', error);
    }
}
