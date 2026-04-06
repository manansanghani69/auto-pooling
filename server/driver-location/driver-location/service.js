import dotenv from 'dotenv';
import { redisClient } from '../common/redis.js';

dotenv.config({ path: new URL('../.env', import.meta.url), override: true });
const DRIVER_LOCATION_CACHE_PREFIX = 'driver-location';
const DRIVER_INFO_CACHE_PREFIX = 'driver-info';
const DEFAULT_NEARBY_DRIVERS_LIMIT = 100;

function getDriverLocationCacheKey() {
  return `${DRIVER_LOCATION_CACHE_PREFIX}`;
}

function getDriverInfoCacheKey(driverId) {
  return `${DRIVER_INFO_CACHE_PREFIX}:${driverId}`;
}

function getNearbyDriversLimit() {
  const configuredLimit = Number(process.env.NEARBY_DRIVERS_LIMIT || DEFAULT_NEARBY_DRIVERS_LIMIT);
  if (Number.isInteger(configuredLimit) && configuredLimit > 0) return configuredLimit;
  return DEFAULT_NEARBY_DRIVERS_LIMIT;
}

function mapNearbyDriver(entry) {
  if (!Array.isArray(entry) || entry.length < 2) return null;

  const [driverId, coordinates] = entry;
  if (typeof driverId !== 'string') return null;
  if (!Array.isArray(coordinates) || coordinates.length < 2) return null;

  const [longitude, latitude] = coordinates;
  return {
    driverId,
    longitude: String(longitude),
    latitude: String(latitude),
    source: 'cache',
  };
}

async function setCachedDriverLocation(driverId, longitude, latitude) {
  const key = getDriverLocationCacheKey();
  try {
    await redisClient.geoadd(key, longitude, latitude, driverId);
  } catch (error) {
    console.error('driver location cache write failed', error);
  }
}

function normalizeDriverInfo(driverId, driverInfo) {
  const payload = { driverId, ...(driverInfo ?? {}) };
  return Object.entries(payload).reduce((accumulator, [key, value]) => {
    if (value === null || value === undefined) return accumulator;
    accumulator[key] = typeof value === 'string' ? value : JSON.stringify(value);
    return accumulator;
  }, {});
}

async function setCachedDriverInfo(driverId, driverInfo) {
  const key = getDriverInfoCacheKey(driverId);
  const normalizedDriverInfo = normalizeDriverInfo(driverId, driverInfo);
  if (Object.keys(normalizedDriverInfo).length === 0) return;

  try {
    await redisClient.hset(key, normalizedDriverInfo);
  } catch (error) {
    console.error('driver info cache write failed', error);
  }
}

async function removeCachedDriverData(driverId) {
  const driverInfoKey = getDriverInfoCacheKey(driverId);
  const driverLocationKey = getDriverLocationCacheKey();
  try {
    await redisClient.pipeline().del(driverInfoKey).zrem(driverLocationKey, driverId).exec();
  } catch (error) {
    console.error('driver cache delete failed', error);
  }
}

export async function updateDriverLocation(driverId, longitude, latitude) {
  await setCachedDriverLocation(driverId, longitude, latitude);
  return { driverId, longitude, latitude };
}

export async function activateDriver(driverId, driverInfo) {
  await setCachedDriverInfo(driverId, driverInfo);
  return { driverId };
}

export async function deactivateDriver(driverId) {
  await removeCachedDriverData(driverId);
  return { driverId };
}

export async function getNearbyDrivers(pickUpLongitude, pickUpLatitude, radius) {
  const key = getDriverLocationCacheKey();
  try {
    const cachedValues = await redisClient.georadius(
      key,
      pickUpLongitude,
      pickUpLatitude,
      radius,
      'km',
      'WITHCOORD',
      'COUNT',
      getNearbyDriversLimit()
    );

    if (!cachedValues || cachedValues.length === 0) return [];
    return cachedValues.map(mapNearbyDriver).filter(Boolean);
  } catch (error) {
    console.error('nearby drivers cache read failed', error);
    return [];
  }
}
