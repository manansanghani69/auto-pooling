# Autopooling Backend (Server)

Node.js/Express API backed by PostgreSQL and Redis. Current features focus on
authentication with phone number + OTP, JWT access tokens, and Redis-backed
refresh tokens.

## Project Contents

- `src/app.js`: Express app setup and route wiring
- `src/index.js`: server entrypoint
- `src/auth/`: auth routes, controller, service, and middleware
- `src/common/db.js`: PostgreSQL connection
- `src/common/redis.js`: Redis connection
- `docker-compose.yml`: local Postgres + Redis

## Prerequisites

- Node.js (LTS recommended)
- Docker + Docker Compose (for local Postgres and Redis)

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
PORT=4000

# OTP settings
OTP_TTL_SECONDS=300
OTP_DIGITS=4
OTP_RETURN_IN_RESPONSE=true
```

3) Create the `users` table

```bash
docker exec -it autopool_postgres psql -U autopool_user -d autopool_db
```

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  phone VARCHAR(15) UNIQUE,
  name TEXT,
  email TEXT,
  profile_photo TEXT,
  gender TEXT,
  password TEXT,
  role VARCHAR CHECK (role IN ('rider','driver','admin')) DEFAULT 'rider',
  created_at TIMESTAMP DEFAULT NOW()
);
```

If the table already exists, add the new columns:

```sql
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS email TEXT,
  ADD COLUMN IF NOT EXISTS profile_photo TEXT,
  ADD COLUMN IF NOT EXISTS gender TEXT;
```

4) Install dependencies

```bash
npm install
```

5) Run the server

```bash
npm start
```

The API listens on `http://localhost:4000` by default.

## API Overview

Base path: `/v1/auth`

- `POST /request-otp` - Request a one-time password for a phone number
- `POST /login` - Login or sign up with phone + otp (name required for new users)
- `POST /refresh` - Refresh access token with a refresh token
- `POST /logout` - Revoke a refresh token
- `DELETE /delete/user` - Protected route; deletes user by `userId`

Base path: `/v1/profile`

- `GET /` - Protected route; requires Bearer access token
- `PATCH /` - Update user details (name, email, profilePhoto, gender)

Health check: `GET /health`

## OTP Flow

1) Call `POST /v1/auth/request-otp` with `{ "phone": "..." }`.
2) Use the returned OTP (or your SMS provider) to call `/login`.
3) On success you receive `{ accessToken, refreshToken }`.

Notes:
- OTPs are stored in Redis and expire after `OTP_TTL_SECONDS`.
- OTPs are invalidated after successful verification.
- In production, set `OTP_RETURN_IN_RESPONSE=false` and deliver OTP via SMS.

## Example Requests

Request OTP:

```bash
curl -X POST http://localhost:4000/v1/auth/request-otp \
  -H "Content-Type: application/json" \
  -d '{"phone":"9999999999"}'
```

Login or signup with OTP:

```bash
curl -X POST http://localhost:4000/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phone":"9999999999","otp":"123456","name":"Manan"}'
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

Update profile:

```bash
curl -X PATCH http://localhost:4000/v1/profile \
  -H "Authorization: Bearer <accessToken>" \
  -H "Content-Type: application/json" \
  -d '{"name":"Manan Sanghani","email":"manan@example.com","profilePhoto":"https://example.com/me.jpg","gender":"male"}'
```

Logout:

```bash
curl -X POST http://localhost:4000/v1/auth/logout \
  -H "Content-Type: application/json" \
  -d '{"refreshToken":"<token>"}'
```

## Notes

- This repo currently implements authentication only.
- SMS delivery for OTPs is not wired; integrate your provider in production.
