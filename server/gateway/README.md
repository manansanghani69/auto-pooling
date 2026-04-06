# API Gateway (Local Development)

This service provides one local entrypoint for all backend services.

## Routes

- `GET /health` -> gateway health
- `GET /v1/auth/health` -> auth service health
- `GET /v1/profile/health` -> profile service health
- `GET /v1/driver-location/health` -> driver-location service health
- `GET /v1/request-trip/health` -> request-trip service health
- `/v1/auth/*` -> auth service
- `/v1/profile/*` -> profile service
- `/v1/driver-location/*` -> driver-location service
- `/ws/request-trip` -> request-trip WebSocket server

## Run

```bash
cp .env.example .env
npm install
npm start
```

Default gateway URL: `http://localhost:8080`
