import dotenv from 'dotenv';
import { redisClient } from '../common/redis.js';

dotenv.config({ path: new URL('../.env', import.meta.url), override: true });

const DRIVER_LOCATION_CACHE_PREFIX = 'driver-location';
const DRIVER_LOCATION_TTL_SECONDS = Number(process.env.DRIVER_LOCATION_TTL_SECONDS || 300);

function getDriverLocationCacheKey() {
  return `${DRIVER_LOCATION_CACHE_PREFIX}`;
}

function getDriverLocationTtlSeconds() {
  if (Number.isInteger(DRIVER_LOCATION_TTL_SECONDS) && DRIVER_LOCATION_TTL_SECONDS > 0) {
    return DRIVER_LOCATION_TTL_SECONDS;
  }
  return 300;
}

function parseCachedLocationValue(cachedValue) {
  if (!cachedValue) return null;

  try {
    // const parsed = JSON.parse(cachedValue);
    console.log('cachedValue', cachedValue);
    return { cachedValue };
  } catch {
    if (cachedValue.trim().length > 0) return cachedValue;
  }

  return null;
}

// async function getCachedDriverLocation(driverId) {
//   const key = getDriverLocationCacheKey();
//   try {
//     const cachedValue = await redisClient.georadius(key, 13.450000, 38.200000, 5, 'km', 'WITHCOORD', 'COUNT', 100);
//     const location = parseCachedLocationValue(cachedValue);
//     if (!location) return null;
//     return { driverId, longitude: location.longitude, latitude: location.latitude, source: 'cache' };
//   } catch (error) {
//     console.error('driver location cache read failed', error);
//     return null;
//   }
// }

async function setCachedDriverLocation(driverId, longitude, latitude) {
  const key = getDriverLocationCacheKey(driverId);
  // const key = DRIVER_LOCATION_CACHE_PREFIX;
  // const payload = JSON.stringify({ longitude, latitude });
  try {
    await redisClient.geoadd(key, longitude, latitude, driverId);
    // await redisClient.set(key, 1, 'EX', getDriverLocationTtlSeconds());
  } catch (error) {
    console.error('driver location cache write failed', error);
  }
}

export async function updateDriverLocation(driverId, longitude, latitude) {
  await setCachedDriverLocation(driverId, longitude, latitude);
  return { driverId, longitude, latitude };
}

// export async function getDriverLocation(driverId) {
//   const cachedLocation = await getCachedDriverLocation(driverId);
//   if (cachedLocation) return cachedLocation;

//   return { driverId, longitude: null, latitude: null };
// }
