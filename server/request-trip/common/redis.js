import { createClient } from 'redis';
import dotenv from 'dotenv';

dotenv.config({ path: new URL('../.env', import.meta.url), override: true });

if (!process.env.REDIS_URL) {
  throw new Error('REDIS_URL environment variable is required');
}

export const redisClient = createClient({ url: process.env.REDIS_URL });

redisClient.on('error', (error) => {
  console.error('Redis error', error);
});

await redisClient.connect();
console.log('connected to Redis');
