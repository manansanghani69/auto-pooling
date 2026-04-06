## [1.1.0] - 2026-04-02
### Changed
- Gateway routing simplified to explicit paths in local development.
- Health checks moved to gateway-friendly paths:
  - `GET /v1/auth/health`
  - `GET /v1/profile/health`
  - `GET /v1/driver-location/health`
  - `GET /v1/request-trip/health`
- Updated Postman collections and local environment to use a single local base URL (`http://localhost:8080`) and socket URL (`ws://localhost:8080`).
