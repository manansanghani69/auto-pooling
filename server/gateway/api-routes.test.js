import test from 'node:test';
import assert from 'node:assert/strict';
import { forwardApiRoute, resolveApiServiceUrl } from './api-routes.js';

const SERVICE_URLS = {
  auth: 'http://localhost:4001',
  profile: 'http://localhost:4002',
  driverLocation: 'http://localhost:4003',
};

test('resolveApiServiceUrl returns auth target for auth routes', () => {
  const target = resolveApiServiceUrl('/v1/auth/request-otp', SERVICE_URLS);
  assert.equal(target, SERVICE_URLS.auth);
});

test('forwardApiRoute proxies matched auth routes and returns true', () => {
  const calls = [];
  const matched = forwardApiRoute({
    pathname: '/v1/auth/request-otp',
    req: { method: 'POST' },
    res: {},
    serviceUrls: SERVICE_URLS,
    forwardRequest: (req, res, target) => calls.push({ req, res, target }),
  });

  assert.equal(matched, true);
  assert.deepEqual(calls, [
    { req: { method: 'POST' }, res: {}, target: SERVICE_URLS.auth },
  ]);
});

test('forwardApiRoute returns false for unknown routes', () => {
  const calls = [];
  const matched = forwardApiRoute({
    pathname: '/v1/unknown/request',
    req: {},
    res: {},
    serviceUrls: SERVICE_URLS,
    forwardRequest: () => calls.push('forwarded'),
  });

  assert.equal(matched, false);
  assert.deepEqual(calls, []);
});
