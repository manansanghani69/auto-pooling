import dotenv from 'dotenv';
import { pool } from '../common/db.js';
import { redisClient } from '../common/redis.js';

dotenv.config();

const DRIVER_LOCATION_CACHE_PREFIX = 'driver-location';
const DRIVER_LOCATION_TTL_SECONDS = Number(process.env.DRIVER_LOCATION_TTL_SECONDS || 300);

function getDriverLocationCacheKey(driverId) {
  return `${DRIVER_LOCATION_CACHE_PREFIX}:${driverId}`;
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
    const parsed = JSON.parse(cachedValue);
    if (parsed && typeof parsed.location === 'string') return parsed.location;
  } catch {
    if (cachedValue.trim().length > 0) return cachedValue;
  }

  return null;
}

async function getCachedDriverLocation(driverId) {
  const key = getDriverLocationCacheKey(driverId);
  try {
    const cachedValue = await redisClient.get(key);
    const location = parseCachedLocationValue(cachedValue);
    if (!location) return null;
    return { driverId, location, source: 'cache' };
  } catch (error) {
    console.error('driver location cache read failed', error);
    return null;
  }
}

async function setCachedDriverLocation(driverId, location) {
  const key = getDriverLocationCacheKey(driverId);
  const payload = JSON.stringify({ location });
  try {
    await redisClient.set(key, payload, { EX: getDriverLocationTtlSeconds() });
  } catch (error) {
    console.error('driver location cache write failed', error);
  }
}

async function replaceDriverLocation(driverId, location) {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    await client.query('DELETE FROM driver_coordinates WHERE driver_id=$1', [driverId]);
    await client.query('INSERT INTO driver_coordinates (driver_id, location) VALUES ($1, $2)', [
      driverId,
      location,
    ]);
    await client.query('COMMIT');
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
}

async function findDriverLocationInDb(driverId) {
  const sql = 'SELECT location FROM driver_coordinates WHERE driver_id=$1 LIMIT 1';
  const result = await pool.query(sql, [driverId]);
  if (!result.rows[0]) return null;
  return { driverId, location: result.rows[0].location, source: 'database' };
}

export async function updateDriverLocation(driverId, location) {
  await replaceDriverLocation(driverId, location);
  await setCachedDriverLocation(driverId, location);
  return { driverId, location };
}

export async function getDriverLocation(driverId) {
  const cachedLocation = await getCachedDriverLocation(driverId);
  if (cachedLocation) return cachedLocation;

  const dbLocation = await findDriverLocationInDb(driverId);
  if (!dbLocation) return null;

  await setCachedDriverLocation(driverId, dbLocation.location);
  return dbLocation;
}
