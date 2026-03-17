# Autopooling Backend (Server)

Node.js/Express API backed by PostgreSQL and Redis.
Current scope is OTP auth plus profile management using separate `rider` and `driver` tables.

## Project Contents

- `src/app.js`: Express app setup and route wiring
- `src/index.js`: server entrypoint
- `src/auth/`: auth routes, controller, service
- `src/profile/`: profile routes, controller, service
- `src/driver-location/`: driver location routes, controller, service
- `src/common/db.js`: PostgreSQL connection
- `src/common/redis.js`: Redis connection
- `src/common/schema.sql`: database schema for rider/driver/trip tables
- `docker-compose.yml`: local Postgres + Redis

## Prerequisites

- Node.js (LTS recommended)
- Docker + Docker Compose

## Setup

1) Start Postgres and Redis

```bash
docker compose up -d
```

2) Create `.env`

```env
DB_HOST=localhost
DB_PORT=5432
DB_USER=autopool_user
DB_PASS=autopool_pass
DB_NAME=autopool_db
JWT_SECRET=supersecretkey
JWT_EXPIRES_IN=15m
REFRESH_TOKEN_EXPIRES_DAYS=30
REDIS_URL=redis://localhost:6379
DRIVER_LOCATION_TTL_SECONDS=300
PORT=4000

# OTP settings
OTP_TTL_SECONDS=300
OTP_DIGITS=4
OTP_RETURN_IN_RESPONSE=true
```

3) Create/Update DB tables

```bash
docker exec -i autopool_postgres psql -U autopool_user -d autopool_db < src/common/schema.sql
```

This creates:
- `rider`
- `driver`
- `driver_coordinates`
- `active_trips`
- `active_requested_trips`

4) Install dependencies

```bash
npm install
```

5) Run the server

```bash
npm start
```

The API listens on `http://localhost:4000` by default.

## Database Schema

`src/common/schema.sql` follows this model:

- `rider(rider_id, phone_no, name, email, photo_link, gender)`
- `driver(driver_id, phone_no, name, email, photo_link, gender, residentail_address, vehical_type, vehical_registration_no, passenger_capacity, vehical_photo, driving_license_photo, vehical_rc_photo, onboarding_status)`
- `driver_coordinates(driver_id, location)`
- `active_trips(trip_id, rider_id, driver_id, fare, start_location, end_location, status)`
- `active_requested_trips(request_id, trip_id, rider_id, rider_location, vehical_type, fare, start_location, end_location, status)`

## API Overview

Base path: `/v1/auth`

- `POST /request-otp` - Request OTP (`phone` or `phone_no`)
- `POST /verify-otp` - Login/signup with OTP (`role` can be `rider` or `driver`)
- `POST /refresh` - Refresh access token with refresh token
- `POST /logout` - Revoke refresh token
- `DELETE /delete/user` - Protected route; deletes authenticated user

Base path: `/v1/profile`

- `GET /` - Protected route; returns current rider/driver profile
- `PATCH /` - Protected route; legacy profile update route (kept for compatibility)
- `POST /rider/create-user` - Protected route; create/complete rider profile (rider token only)
- `POST|PATCH /rider/edit-user` - Protected route; edit rider profile (rider token only)
- `POST /driver/create-user` - Protected route; create/complete driver profile (driver token only)
- `POST|PATCH /driver/edit-user` - Protected route; edit driver profile (driver token only)
- `POST|PATCH /driver/verify-document` - Protected route; upload required driver docs and mark onboarding as `documents_uploaded`

Base path: `/v1/driver-location`

- `PATCH /` - Protected route; update authenticated driver location (`driver` token only)
- `GET /:driverId` - Protected route; fetch current location for a driver (Redis-first, DB fallback)

Health check: `GET /health`

## OTP Flow

1) Call `POST /v1/auth/request-otp` with `{ "phone": "..." }`.
2) Use returned OTP (or your SMS provider) with `POST /v1/auth/verify-otp`.
3) On success, API returns `{ accessToken, refreshToken }`.

Notes:
- OTPs are stored in Redis and expire after `OTP_TTL_SECONDS`.
- OTPs are invalidated after successful verification.
- In production, set `OTP_RETURN_IN_RESPONSE=false` and integrate SMS delivery.

## Example Requests

Request OTP:

```bash
curl -X POST http://localhost:4000/v1/auth/request-otp \
  -H "Content-Type: application/json" \
  -d '{"phone":"9999999999"}'
```

Verify OTP (new rider):

```bash
curl -X POST http://localhost:4000/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"phone":"9999999999","otp":"1234","name":"Manan","role":"rider"}'
```

Refresh token:

```bash
curl -X POST http://localhost:4000/v1/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{"refreshToken":"<token>"}'
```

Access protected route:

```bash
curl -H "Authorization: Bearer <accessToken>" \
  http://localhost:4000/v1/profile
```

Create rider profile:

```bash
curl -X POST http://localhost:4000/v1/profile/rider/create-user \
  -H "Authorization: Bearer <riderAccessToken>" \
  -H "Content-Type: application/json" \
  -d '{"name":"Manan Sanghani","email":"manan@example.com","gender":"male"}'
```

Edit driver profile:

```bash
curl -X PATCH http://localhost:4000/v1/profile/driver/edit-user \
  -H "Authorization: Bearer <driverAccessToken>" \
  -H "Content-Type: application/json" \
  -d '{"name":"Driver One","residentail_address":"Ahmedabad","vehical_type":"SUV","vehical_registration_no":"GJ01AB1234","passenger_capacity":4}'
```

Verify driver documents:

```bash
curl -X PATCH http://localhost:4000/v1/profile/driver/verify-document \
  -H "Authorization: Bearer <driverAccessToken>" \
  -H "Content-Type: application/json" \
  -d '{"vehical_photo":"https://example.com/car.jpg","driving_license_photo":"https://example.com/license.jpg","vehical_rc_photo":"https://example.com/rc.jpg"}'
```

Update driver location:

```bash
curl -X PATCH http://localhost:4000/v1/driver-location \
  -H "Authorization: Bearer <driverAccessToken>" \
  -H "Content-Type: application/json" \
  -d '{"location":"23.0225,72.5714"}'
```

Get driver location:

```bash
curl -H "Authorization: Bearer <accessToken>" \
  http://localhost:4000/v1/driver-location/<driverId>
```

Legacy profile update:

```bash
curl -X PATCH http://localhost:4000/v1/profile \
  -H "Authorization: Bearer <accessToken>" \
  -H "Content-Type: application/json" \
  -d '{"name":"Manan Sanghani","email":"manan@example.com","photo_link":"https://example.com/me.jpg","gender":"male"}'
```

Logout:

```bash
curl -X POST http://localhost:4000/v1/auth/logout \
  -H "Content-Type: application/json" \
  -d '{"refreshToken":"<token>"}'
```

## Notes

- Current API implementation uses rider/driver profile + auth only.
- Trip-related tables are created but trip APIs are not yet implemented.
