# System Flow

## Architecture Summary

Microservices:

- `auth` (REST, Redis, PostgreSQL)
- `profile` (REST, PostgreSQL)
- `driver-location` (REST + gRPC, Redis GEO)
- `request-trip` (WebSocket + gRPC client, Redis cache + pub/sub)
- `gateway` (REST/WS reverse proxy for local client entrypoint)

Shared stores/infrastructure:

- PostgreSQL for rider/driver profile records
- Redis per service
  - Auth Redis: OTP + refresh token storage
  - Driver-location Redis: geospatial driver coordinates
  - Request-trip Redis: trip state cache + pub/sub (`ride-requests`)

Protocols:

- REST for auth/profile/location updates and health
- gRPC from request-trip -> driver-location for nearby-driver lookup
- WebSocket for real-time ride lifecycle events

---

## End-to-End Lifecycle

## 1) Authentication and Identity Setup

1. Rider/driver requests OTP via `POST /v1/auth/request-otp`.
2. Auth service stores OTP in Redis (`otp:<phone>`) with TTL.
3. Client verifies OTP via `POST /v1/auth/verify-otp`.
4. Auth service:
   - Validates OTP from Redis with timing-safe compare.
   - Creates user in PostgreSQL if needed.
   - Issues JWT access token (`sub`, `role`) and refresh token UUID.
   - Stores refresh token in Redis (`refresh:<uuid>`) with TTL.
5. Client uses access token for profile/location/socket calls.

## 2) Driver Onboarding and Location Availability

1. Driver completes profile via `profile` endpoints:
   - `/v1/profile/driver/create-user`
   - `/v1/profile/driver/verify-document`
2. Driver app sends location updates via:
   - `PATCH /v1/driver-location` with `longitude` + `latitude`
3. Driver-location service validates role and coordinates, then writes to Redis GEO:
   - key: `driver-location`
   - value: `driverId` with coordinates

## 3) Ride Request Initiation (WebSocket)

1. Rider connects to `ws://<gateway>/ws/request-trip?token=<jwt>`.
2. Request-trip socket server verifies JWT and registers rider connection by `userId`.
3. Rider emits:

```json
{
  "event": "trip.request",
  "data": {
    "pickupLongitude": "72.5714",
    "pickupLatitude": "23.0225",
    "dropoffLongitude": "72.6120",
    "dropoffLatitude": "23.0456"
  }
}
```

4. Request-trip service calls driver-location gRPC:
   - `DriverLocation.DriverLocation/FindNearByDrivers`
   - request: pickup coordinates + radius
5. Driver-location gRPC handler queries Redis GEO radius and returns nearby drivers.
6. Request-trip service creates requested-trip object and caches it in Redis:
   - key: `trip:requested:<tripRequestId>`
7. Request-trip publishes payload to Redis pub/sub channel:
   - channel: `ride-requests`
8. Request-trip emits socket events:
   - Rider gets `trip.requested`
   - Nearby connected drivers get `trip.request.available`

## 4) Ride Acceptance

1. Driver emits:

```json
{
  "event": "trip.accept",
  "data": {
    "tripRequestId": "<uuid>"
  }
}
```

2. Request-trip service executes Redis optimistic locking flow:
   - `WATCH trip:requested:<id>`
   - Validate trip exists and driver is eligible (present in nearby drivers list)
   - `MULTI` transaction:
     - `SET trip:active:<id> <activeTripPayload> EX <ttl>`
     - `DEL trip:requested:<id>`
   - `EXEC`
3. If transaction succeeds:
   - Driver receives `trip.accepted`
   - Rider receives `trip.accepted`
4. If trip unavailable/already claimed:
   - Driver receives socket error code `TRIP_NOT_AVAILABLE`

---

## Service Interaction Map

### REST interactions

- Client -> Gateway (`/v1/auth/*`, `/v1/profile/*`, `/v1/driver-location/*`)
- Gateway -> Auth (`/v1/auth/*`)
- Gateway -> Profile (`/v1/profile/*`)
- Gateway -> Driver-location (`/v1/driver-location/*`)
- Client (debug only) -> Request-trip (`/health`)

### gRPC interactions

- Request-trip -> Driver-location:
  - `FindNearByDrivers` for rider pickup location

### Redis interactions

- Auth Redis:
  - OTP write/read/delete
  - Refresh token write/read/delete/rotation
- Driver-location Redis:
  - `GEOADD` for driver updates
  - `GEORADIUS` for nearby-driver search
- Request-trip Redis:
  - Requested trip cache (`trip:requested:*`)
  - Active trip cache (`trip:active:*`)
  - Pub/sub broadcast (`ride-requests`)
  - Atomic accept transition (`WATCH` + `MULTI/EXEC`)

### Socket interactions

- Client -> Gateway WebSocket:
  - `trip.request` (rider only)
  - `trip.accept` (driver only)
- Gateway -> Request-trip WebSocket:
  - `/ws/request-trip` upgrade passthrough
- Request-trip -> clients:
  - `connection.ready`
  - `trip.requested`
  - `trip.request.available`
  - `trip.accepted`
  - `error`

---

## Error Propagation Notes

- gRPC outage or call failure maps to WebSocket `DRIVER_LOCATION_UNAVAILABLE`.
- Socket payload schema failures map to `VALIDATION_ERROR`.
- Unauthorized socket handshake closes with status code `4401`.
- Competing driver accepts are handled via Redis transaction conflict (`EXEC === null`) and return `TRIP_NOT_AVAILABLE`.
