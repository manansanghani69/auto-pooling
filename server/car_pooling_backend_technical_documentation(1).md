# Backend Development Documentation — Autopooling Project

This file consolidates all backend development steps for the **Autopooling App**, starting from environment setup to feature-specific backend modules.  
Future steps (like Driver Service, Ride Management, Pooling Engine, etc.) will be appended sequentially.

---

# Backend Setup Summary — Autopooling Project (Node.js)

## 🎯 Goal
Setup a working **backend environment** for the Autopooling app using **Node.js**, **PostgreSQL**, and **Redis**. This is the **first step** before implementing Auth APIs.

---

## 🧱 1. Environment Setup

### Tech Stack
- **Backend:** Node.js (Express / NestJS)
- **Database:** PostgreSQL (later with PostGIS)
- **Cache:** Redis
- **Docs:** Swagger / Postman for testing
- **Containerization:** Docker + Docker Compose

### Folder Structure
```
server/
 ┣ /src
 ┃ ┣ /common
 ┃ ┃ ┗ db.js
 ┃ ┗ testDb.js
 ┣ .env
 ┣ docker-compose.yml
 ┣ package.json
 ┗ README.md
```

---

## ⚙️ 2. Docker Configuration
**File:** `docker-compose.yml`
```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15
    container_name: autopool_postgres
    restart: always
    environment:
      POSTGRES_USER: autopool_user
      POSTGRES_PASSWORD: autopool_pass
      POSTGRES_DB: autopool_db
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7
    container_name: autopool_redis
    restart: always
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```
Run:
```bash
docker compose up -d
```

---

## 🔐 3. Environment Variables
**File:** `.env`
```
DB_HOST=localhost
DB_PORT=5432
DB_USER=autopool_user
DB_PASS=autopool_pass
DB_NAME=autopool_db
JWT_SECRET=supersecretkey
```

---

## 📦 4. Package Configuration
Install dependencies:
```bash
npm init -y
npm install express pg redis dotenv jsonwebtoken bcrypt cors
```

**package.json:**
```json
{
  "name": "autopool-backend",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "start": "node src/testDb.js"
  },
  "dependencies": {
    "bcrypt": "^5.1.1",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "express": "^4.19.2",
    "jsonwebtoken": "^9.0.2",
    "pg": "^8.11.3",
    "redis": "^4.6.7"
  }
}
```

---

## 🗄️ 5. Database Connection
**File:** `/src/common/db.js`
```js
import pkg from 'pg';
import dotenv from 'dotenv';
dotenv.config();

const { Pool } = pkg;

export const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
});

pool.on('connect', () => {
  console.log('✅ Connected to PostgreSQL database');
});

pool.on('error', (err) => {
  console.error('❌ PostgreSQL error:', err);
});
```

---

## 🧪 6. Connection Test
**File:** `/src/testDb.js`
```js
import { pool } from './common/db.js';

(async () => {
  try {
    const res = await pool.query('SELECT NOW()');
    console.log('✅ Database connected successfully at:', res.rows[0].now);
  } catch (err) {
    console.error('❌ Database connection failed:', err);
  } finally {
    await pool.end();
  }
})();
```
Run:
```bash
npm start
```
Expected output:
```
✅ Connected to PostgreSQL database
✅ Database connected successfully at: 2025-11-03T17:28:12.654Z
```

---

## 🧩 7. Optional — Create `users` Table
Inside container:
```bash
docker exec -it autopool_postgres psql -U autopool_user -d autopool_db
```
Run SQL:
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
  role VARCHAR CHECK (role IN ('rider','driver','admin')),
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## ✅ Outcome
- PostgreSQL + Redis running in Docker
- Node.js connected successfully
- Verified DB connection
- Backend environment ready for Auth APIs (next step)



---

# Step 2 — Authentication Service (Auth)

This document explains how to build the **Authentication and User Management Service** for the Autopooling backend.  
It’s based on the setup from `backend_getting_started_autopooling.md` and `backend_setup_summary.md`.

---

## 🎯 Purpose
Provide secure user authentication and authorization using:
- **JWT access tokens** for short-lived user sessions.
- **Refresh tokens** stored in **Redis** for session renewal.
- **PostgreSQL** for user storage.

---

## ⚙️ Environment Setup

Add the following to your `.env` file:
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
```

Install dependencies:
```bash
npm install express pg dotenv bcrypt jsonwebtoken redis uuid
```

---

## 🧱 Database Schema

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
  kyc_status VARCHAR DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## 📂 Folder Structure

```
/server
 ┣ /src
 ┃ ┣ /auth
 ┃ ┃ ┣ controller.js
 ┃ ┃ ┣ service.js
 ┃ ┃ ┣ routes.js
 ┃ ┃ ┗ middleware.js
 ┃ ┣ /common
 ┃ ┃ ┣ db.js
 ┃ ┃ ┗ redis.js
 ┃ ┣ app.js
 ┗ index.js
```

---

## 🔑 Core Code Summary

### `signAccessToken(payload)`
```js
function signAccessToken(payload) {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: ACCESS_EXPIRES });
}
```
Creates a **JWT** containing user info (e.g., user ID, role), signs it with `JWT_SECRET`, and sets an expiry time (`ACCESS_EXPIRES`).

---

### `issueTokens(user)`
```js
export async function issueTokens(user) {
  const accessToken = signAccessToken({ sub: user.id, role: user.role });
  const refreshToken = signRefreshToken();

  const key = `refresh:${refreshToken}`;
  await redisClient.set(key, user.id, { EX: REFRESH_DAYS * 24 * 60 * 60 });

  return { accessToken, refreshToken, expiresIn: ACCESS_EXPIRES };
}
```

**Function role:**
1. Generates an **access token** for API authentication.
2. Generates a **refresh token** (UUID string).
3. Saves the refresh token in Redis with expiry (e.g., 30 days).
4. Returns both tokens to the client.

**Why:**
- Access token = short-lived, used in every request.
- Refresh token = long-lived, used to renew the session.

---

## 🧩 Available Endpoints

| Method | Endpoint | Description |
|--------|-----------|-------------|
| POST | `/v1/auth/signup` | Register a new user |
| POST | `/v1/auth/login` | Authenticate existing user |
| POST | `/v1/auth/refresh` | Issue new access token |
| POST | `/v1/auth/logout` | Invalidate refresh token |
| GET | `/v1/auth/profile` | Get user profile (protected) |

---

## 🧠 Auth Flow Overview

1. **Signup/Login:**  
   User provides phone + password → backend validates and calls `issueTokens()`.  
   Response: `{ accessToken, refreshToken }`.

2. **Using Access Token:**  
   Frontend includes `Authorization: Bearer <accessToken>` in every API call.  
   Backend validates it with middleware using `jwt.verify()`.

3. **Token Expiry:**  
   When the access token expires, frontend calls `/v1/auth/refresh` with the refresh token.  
   A new pair of tokens is issued.

4. **Logout:**  
   Frontend calls `/v1/auth/logout`.  
   Backend deletes the refresh token from Redis → session is revoked.

---

## 🧪 Example Usage

### Signup
```bash
curl -X POST http://localhost:4000/v1/auth/signup   -H "Content-Type: application/json"   -d '{"phone":"9999999999","name":"Manan","password":"pass1234"}'
```

### Login
```bash
curl -X POST http://localhost:4000/v1/auth/login   -H "Content-Type: application/json"   -d '{"phone":"9999999999","password":"pass1234"}'
```

### Access Protected Route
```bash
curl -H "Authorization: Bearer <accessToken>"   http://localhost:4000/v1/auth/profile
```

### Refresh Token
```bash
curl -X POST http://localhost:4000/v1/auth/refresh   -H "Content-Type: application/json"   -d '{"refreshToken":"<token>"}'
```

---

## 🔒 Security Best Practices

- Always **hash passwords** using bcrypt (`10+` salt rounds).  
- Keep `JWT_SECRET` private and rotate periodically.  
- Use **HTTPS** in production.  
- Limit login attempts (prevent brute force).  
- Expire refresh tokens on logout or password reset.  
- Avoid storing sensitive info (like password) in JWT payloads.  
- Use **short-lived access tokens** and **long-lived refresh tokens** for best balance.

---

## 🚀 Next Steps

- Add **OTP-based login** (SMS/email).  
- Implement **Role-based access control (RBAC)** for drivers/admins.  
- Add **token blacklist** for password change events.  
- Integrate with **Flutter frontend** for mobile login flow.

---

## ✅ Summary

This step builds the **authentication foundation** for Autopooling:
- Secure user creation & login.
- JWT-based access control.
- Redis-backed refresh tokens.
- Easy integration with frontend.
- Extensible for roles, OTP, and admin access.

It ensures fast, secure, and scalable authentication across all Autopooling modules.


---

## 🧭 Next Planned Steps

### Step 3 — Driver Service
Will handle vehicle registration, availability, and driver profile verification.

### Step 4 — Ride Management Service
Responsible for ride requests, tracking, and linking riders to drivers.

### Step 5 — Pooling Engine
Implements intelligent ride matching using Redis geospatial queries.

Further modules will be documented and appended in continuation of this file.
