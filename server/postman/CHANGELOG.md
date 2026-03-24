## [1.2.0] — 2026-03-24
### Changed
- `PATCH /v1/driver-location` — request body changed from `location` string to `longitude` + `latitude` coordinate fields.
- `GET /v1/driver-location/:driverId` — removed from current HTTP API contract.
- `PATCH /v1/request-trip/rider/request-ride` — added rider ride-request endpoint.
- `GET /v1/request-trip/driver/accept-ride` — added driver ride-acceptance endpoint with `rideRequestId` query.
- `DriverLocation.FindNearByDrivers` (gRPC) — added gRPC request/response reference examples in Postman.

## [1.1.0] — 2026-03-14
### Changed
- `PATCH /v1/driver-location` — added driver location update endpoint (Redis cache + DB persistence).
- `GET /v1/driver-location/:driverId` — added driver location fetch endpoint with cache-first read.

## [1.0.0] — 2026-03-12
### Changed
- `GET /health` — added request and response examples.
- `POST /v1/auth/request-otp` — added request body and success/error examples.
- `POST /v1/auth/verify-otp` — added request body and success/error examples.
- `POST /v1/auth/refresh` — added request body and success/error examples.
- `POST /v1/auth/logout` — added request body and success response example.
- `DELETE /v1/auth/delete/user` — added authorization header and success/error examples.
- `GET /v1/profile` — added authorization header and success response example.
- `PATCH /v1/profile` — added authorization header, request body, and success response example.
- `POST /v1/profile/rider/create-user` — added authorization header, request body, and success/error examples.
- `POST /v1/profile/rider/edit-user` — added authorization header, request body, and success response example.
- `PATCH /v1/profile/rider/edit-user` — added authorization header, request body, and success response example.
- `POST /v1/profile/driver/create-user` — added authorization header, request body, and success response example.
- `POST /v1/profile/driver/edit-user` — added authorization header, request body, and success response example.
- `PATCH /v1/profile/driver/edit-user` — added authorization header, request body, and success response example.
- `POST /v1/profile/driver/verify-document` — added authorization header, request body, and success/error examples.
- `PATCH /v1/profile/driver/verify-document` — added authorization header, request body, and success response example.
