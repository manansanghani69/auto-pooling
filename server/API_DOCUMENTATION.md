# API Documentation

## Overview

This backend is composed of four microservices:

- `auth` (`http://localhost:4001`)
- `profile` (`http://localhost:4002`)
- `driver-location` (`http://localhost:4003`)
- `request-trip` (`http://localhost:4004`)

Local development also includes an API gateway:

- `gateway` (`http://localhost:8080`) for all client HTTP calls
- `gateway websocket` (`ws://localhost:8080/ws/request-trip`) for trip sockets
- upstream health passthroughs:
  - `GET /v1/auth/health`
  - `GET /v1/profile/health`
  - `GET /v1/driver-location/health`
  - `GET /v1/request-trip/health`

Transport protocols:

- REST (Express)
- gRPC (`DriverLocation.DriverLocation/FindNearByDrivers`)
- WebSocket (`ws://localhost:8080/ws/request-trip` through gateway)

Recommended local Postman/Client variables:

- `gateway_base_url=http://localhost:8080`
- `auth_base_url=http://localhost:8080`
- `profile_base_url=http://localhost:8080`
- `driver_location_base_url=http://localhost:8080`
- `request_trip_base_url=http://localhost:8080`
- `socket_url=ws://localhost:8080`

## Authentication

- Auth mechanism: JWT bearer access token (`Authorization: Bearer <token>`).
- Token issuer: `POST /v1/auth/verify-otp`.
- Refresh mechanism: `POST /v1/auth/refresh` with refresh token UUID.
- Refresh tokens are rotated on refresh and stored in Redis.
- WebSocket auth supports either:
  - Query param `?token=<accessToken>`
  - Header `Authorization: Bearer <accessToken>`
- No OAuth2/API key flow found in codebase.

---

## REST APIs

### Common Error Shape

```json
{
  "status": "error",
  "code": 400,
  "data": null,
  "error": {
    "message": "validation error",
    "details": [
      {
        "field": "longitude",
        "message": "longitude is out of range"
      }
    ]
  }
}
```

## Auth Service (`{{auth_base_url}}`)

### Health Check

- Endpoint name: Auth Health
- Description: Liveness probe for auth service.
- Method & URL: `GET {{auth_base_url}}/v1/auth/health`
- Headers: none
- Request body schema: none
- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "ok": true,
    "service": "auth"
  }
}
```

- Example request:

```bash
curl {{auth_base_url}}/v1/auth/health
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": { "ok": true, "service": "auth" }
}
```

- Error cases: `500 server error`

### Request OTP

- Endpoint name: Request OTP
- Description: Generates and stores OTP in Redis for phone number.
- Method & URL: `POST {{auth_base_url}}/v1/auth/request-otp`
- Headers: `Content-Type: application/json`
- Request body schema:

```json
{
  "phone": "string"
}
```

`phone_no` is also accepted.

- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "ok": true,
    "expiresIn": 300,
    "otp": "4821"
  }
}
```

- Example request:

```json
{
  "phone": "9999999999"
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": { "ok": true, "expiresIn": 300, "otp": "4821" }
}
```

- Error cases:
  - `400 phone required`
  - `500 server error`

### Verify OTP (Login/Signup)

- Endpoint name: Verify OTP
- Description: Verifies OTP, resolves/creates user (`rider`/`driver`), issues access and refresh tokens.
- Method & URL: `POST {{auth_base_url}}/v1/auth/verify-otp`
- Headers: `Content-Type: application/json`
- Request body schema:

```json
{
  "phone": "string",
  "otp": "string",
  "name": "string",
  "role": "rider | driver"
}
```

- Response schema:

```json
{
  "status": "success",
  "code": 201,
  "data": {
    "user": {
      "id": "string",
      "role": "rider",
      "phone_no": "string"
    },
    "tokens": {
      "accessToken": "jwt",
      "refreshToken": "uuid",
      "expiresIn": "15m"
    },
    "isNewUser": true
  }
}
```

- Example request:

```json
{
  "phone": "9999999999",
  "otp": "1234",
  "name": "Rider One",
  "role": "rider"
}
```

- Example response:

```json
{
  "status": "success",
  "code": 201,
  "data": {
    "user": { "id": "rider-uuid", "role": "rider", "phone_no": "9999999999" },
    "tokens": { "accessToken": "<jwt>", "refreshToken": "<uuid>", "expiresIn": "15m" },
    "isNewUser": true
  }
}
```

- Error cases:
  - `400 role must be rider or driver`
  - `400 phone & otp required`
  - `401 invalid otp`
  - `500 server error`

### Refresh Token

- Endpoint name: Refresh Access Token
- Description: Validates refresh token from Redis, rotates refresh token, returns new access token.
- Method & URL: `POST {{auth_base_url}}/v1/auth/refresh`
- Headers: `Content-Type: application/json`
- Request body schema:

```json
{
  "refreshToken": "uuid"
}
```

- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "accessToken": "jwt",
    "refreshToken": "uuid"
  }
}
```

- Example request:

```json
{
  "refreshToken": "<refresh-token>"
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": { "accessToken": "<new-jwt>", "refreshToken": "<new-refresh-token>" }
}
```

- Error cases:
  - `400 refreshToken required`
  - `401 invalid refresh token`

### Logout

- Endpoint name: Logout
- Description: Revokes refresh token if provided.
- Method & URL: `POST {{auth_base_url}}/v1/auth/logout`
- Headers: `Content-Type: application/json`
- Request body schema:

```json
{
  "refreshToken": "uuid"
}
```

- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": { "ok": true }
}
```

- Example request:

```json
{
  "refreshToken": "<refresh-token>"
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": { "ok": true }
}
```

- Error cases: `500 server error`

### Delete Account

- Endpoint name: Delete Account
- Description: Deletes authenticated user record from rider/driver table.
- Method & URL: `DELETE {{auth_base_url}}/v1/auth/delete/user`
- Headers:
  - `Authorization: Bearer <accessToken>`
  - `Content-Type: application/json` (optional fallback body)
- Request body schema (optional fallback):

```json
{
  "userId": "string",
  "role": "rider | driver"
}
```

- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": { "ok": true }
}
```

- Example request:

```bash
curl -X DELETE {{auth_base_url}}/v1/auth/delete/user \
  -H "Authorization: Bearer <access-token>"
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": { "ok": true }
}
```

- Error cases:
  - `401 missing auth header / invalid token / unauthorized`
  - `404 user not found`
  - `500 server error`

## Profile Service (`{{profile_base_url}}`)

### Health Check

- Endpoint name: Profile Health
- Description: Liveness probe.
- Method & URL: `GET {{profile_base_url}}/v1/profile/health`
- Headers: none
- Request body schema: none
- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "ok": true,
    "service": "profile"
  }
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": { "ok": true, "service": "profile" }
}
```

- Error cases: `500 server error`

### Get Profile

- Endpoint name: Get Authenticated Profile
- Description: Returns profile row for authenticated user.
- Method & URL: `GET {{profile_base_url}}/v1/profile`
- Headers: `Authorization: Bearer <accessToken>`
- Request body schema: none
- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "user": {
      "id": "string",
      "role": "rider | driver",
      "phone_no": "string"
    }
  }
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "user": {
      "id": "rider-uuid",
      "role": "rider",
      "phone_no": "9999999999",
      "name": "Rider One"
    }
  }
}
```

- Error cases:
  - `401 unauthorized`
  - `404 user not found`
  - `500 server error`

### Update Profile (Role-aware)

- Endpoint name: Update Profile
- Description: Routes to rider or driver update logic based on JWT role.
- Method & URL: `PATCH {{profile_base_url}}/v1/profile`
- Headers:
  - `Authorization: Bearer <accessToken>`
  - `Content-Type: application/json`
- Request body schema:

Rider-compatible fields:

```json
{
  "name": "string",
  "email": "string(email)",
  "photo_link": "string(url)",
  "gender": "male | female | other"
}
```

Driver-compatible fields include rider fields plus:

```json
{
  "residentail_address": "string",
  "vehical_type": "string",
  "vehical_registration_no": "string",
  "passenger_capacity": 4,
  "vehical_photo": "string(url)",
  "driving_license_photo": "string(url)",
  "vehical_rc_photo": "string(url)"
}
```

- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "user": {}
  }
}
```

- Example request:

```json
{
  "name": "Rider One Updated",
  "email": "rider.updated@example.com"
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": { "user": { "id": "rider-uuid", "name": "Rider One Updated" } }
}
```

- Error cases:
  - `400 validation messages (email/gender/url/empty payload)`
  - `401 unauthorized`
  - `500 server error`

### Create Rider User

- Endpoint name: Create Rider Profile
- Description: Completes rider profile (rider role only).
- Method & URL: `POST {{profile_base_url}}/v1/profile/rider/create-user`
- Headers:
  - `Authorization: Bearer <riderAccessToken>`
  - `Content-Type: application/json`
- Request body schema:

```json
{
  "name": "string",
  "email": "string(email)",
  "photo_link": "string(url)",
  "gender": "male | female | other"
}
```

- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "user": {}
  }
}
```

- Example request:

```json
{
  "name": "Rider One",
  "email": "rider.one@example.com",
  "gender": "male"
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": { "user": { "id": "rider-uuid", "name": "Rider One" } }
}
```

- Error cases:
  - `400 missing required field(s): name`
  - `403 forbidden` (wrong role)
  - `500 server error`

### Edit Rider User

- Endpoint name: Edit Rider Profile
- Description: Updates rider profile.
- Method & URL:
  - `POST {{profile_base_url}}/v1/profile/rider/edit-user`
  - `PATCH {{profile_base_url}}/v1/profile/rider/edit-user`
- Headers:
  - `Authorization: Bearer <riderAccessToken>`
  - `Content-Type: application/json`
- Request body schema: same as rider fields above.
- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "user": {}
  }
}
```

- Example request:

```json
{
  "name": "Rider One v2"
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": { "user": { "id": "rider-uuid", "name": "Rider One v2" } }
}
```

- Error cases:
  - `400 no profile fields provided`
  - `401 unauthorized`
  - `403 forbidden`
  - `500 server error`

### Create Driver User

- Endpoint name: Create Driver Profile
- Description: Completes required driver profile fields.
- Method & URL: `POST {{profile_base_url}}/v1/profile/driver/create-user`
- Headers:
  - `Authorization: Bearer <driverAccessToken>`
  - `Content-Type: application/json`
- Request body schema:

```json
{
  "name": "string",
  "residentail_address": "string",
  "vehical_type": "string",
  "vehical_registration_no": "string",
  "passenger_capacity": 4,
  "email": "string(email)",
  "photo_link": "string(url)",
  "gender": "male | female | other"
}
```

- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "user": {
      "onboarding_status": "info_remaining | documents_uploaded | approved | rejected"
    }
  }
}
```

- Example request:

```json
{
  "name": "Driver One",
  "residentail_address": "Satellite, Ahmedabad",
  "vehical_type": "SUV",
  "vehical_registration_no": "GJ01AB1234",
  "passenger_capacity": 4
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "user": {
      "id": "driver-uuid",
      "name": "Driver One",
      "vehical_type": "SUV",
      "onboarding_status": "info_remaining"
    }
  }
}
```

- Error cases:
  - `400 missing required field(s)`
  - `400 passenger_capacity must be positive integer`
  - `400 passenger_capacity cannot be greater than 20`
  - `403 forbidden`
  - `500 server error`

### Edit Driver User

- Endpoint name: Edit Driver Profile
- Description: Partial updates for driver profile and optional document URLs.
- Method & URL:
  - `POST {{profile_base_url}}/v1/profile/driver/edit-user`
  - `PATCH {{profile_base_url}}/v1/profile/driver/edit-user`
- Headers:
  - `Authorization: Bearer <driverAccessToken>`
  - `Content-Type: application/json`
- Request body schema: same as driver fields above.
- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "user": {}
  }
}
```

- Example request:

```json
{
  "passenger_capacity": 5,
  "vehical_type": "MUV"
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": { "user": { "id": "driver-uuid", "passenger_capacity": 5 } }
}
```

- Error cases:
  - `400 onboarding_status cannot be set directly`
  - `400 no profile fields provided`
  - `403 forbidden`
  - `500 server error`

### Verify Driver Document

- Endpoint name: Verify Driver Documents
- Description: Requires all three document URLs; sets onboarding status to `documents_uploaded`.
- Method & URL:
  - `POST {{profile_base_url}}/v1/profile/driver/verify-document`
  - `PATCH {{profile_base_url}}/v1/profile/driver/verify-document`
- Headers:
  - `Authorization: Bearer <driverAccessToken>`
  - `Content-Type: application/json`
- Request body schema:

```json
{
  "vehical_photo": "string(url)",
  "driving_license_photo": "string(url)",
  "vehical_rc_photo": "string(url)"
}
```

- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "user": {
      "onboarding_status": "documents_uploaded"
    }
  }
}
```

- Example request:

```json
{
  "vehical_photo": "https://cdn.example.com/docs/vehicle.jpg",
  "driving_license_photo": "https://cdn.example.com/docs/license.jpg",
  "vehical_rc_photo": "https://cdn.example.com/docs/rc.jpg"
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": { "user": { "id": "driver-uuid", "onboarding_status": "documents_uploaded" } }
}
```

- Error cases:
  - `400 vehical_photo, driving_license_photo and vehical_rc_photo are required`
  - `403 forbidden`
  - `500 server error`

## Driver Location Service (`{{driver_location_base_url}}`)

### Health Check

- Endpoint name: Driver Location Health
- Description: Liveness probe.
- Method & URL: `GET {{driver_location_base_url}}/v1/driver-location/health`
- Headers: none
- Request body schema: none
- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "ok": true,
    "service": "driver-location"
  }
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": { "ok": true, "service": "driver-location" }
}
```

- Error cases: `500 server error`

### Update Driver Location

- Endpoint name: Update Driver Location
- Description: Saves driver coordinates in Redis GEO set (`driver-location` key).
- Method & URL: `PATCH {{driver_location_base_url}}/v1/driver-location`
- Headers:
  - `Authorization: Bearer <driverAccessToken>`
  - `Content-Type: application/json`
- Request body schema:

```json
{
  "longitude": "string(number between -180 and 180)",
  "latitude": "string(number between -90 and 90)"
}
```

- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "driverLocation": {
      "driverId": "string",
      "longitude": "string",
      "latitude": "string"
    }
  }
}
```

- Example request:

```json
{
  "longitude": "72.5714",
  "latitude": "23.0225"
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "driverLocation": {
      "driverId": "driver-uuid",
      "longitude": "72.5714",
      "latitude": "23.0225"
    }
  }
}
```

- Error cases:
  - `400 validation error` with `details[]`
  - `401 unauthorized`
  - `403 forbidden` (non-driver role)
  - `404 driver not found` (DB FK violation code `23503`)
  - `500 server error`

## Request Trip Service (`{{request_trip_base_url}}`)

### Health Check

- Endpoint name: Request Trip Health
- Description: Liveness probe.
- Method & URL: `GET {{request_trip_base_url}}/v1/request-trip/health`
- Headers: none
- Request body schema: none
- Response schema:

```json
{
  "status": "success",
  "code": 200,
  "data": {
    "ok": true,
    "service": "request-trip"
  }
}
```

- Example response:

```json
{
  "status": "success",
  "code": 200,
  "data": { "ok": true, "service": "request-trip" }
}
```

- Error cases: `500 server error`

---

## gRPC Documentation

Proto file: `driver-location/protos/nearby_drivers.proto`

Service:

- `package DriverLocation`
- `service DriverLocation`
- `rpc FindNearByDrivers(UserLocation) returns (NearByDrivers)`

### Method: FindNearByDrivers

- Description: Returns drivers near pickup coordinates by querying Redis GEO index.
- Host: `{{grpc_host}}` (default `localhost:50051`)
- Request schema:

```json
{
  "pickUpLongitude": "string",
  "pickUpLatitude": "string",
  "radius": "string"
}
```

- Response schema:

```json
{
  "drivers": [
    {
      "driverId": "string",
      "longitute": "string",
      "latitude": "string"
    }
  ]
}
```

- Example request:

```json
{
  "pickUpLongitude": "72.5714",
  "pickUpLatitude": "23.0225",
  "radius": "5"
}
```

- Example response:

```json
{
  "drivers": [
    {
      "driverId": "driver-uuid-1",
      "longitute": "72.5714",
      "latitude": "23.0225"
    }
  ]
}
```

- Error cases:
  - gRPC `INVALID_ARGUMENT (3)` on schema/range validation failures
  - gRPC `INTERNAL (13)` on unexpected server errors

### Testing via Postman gRPC

1. Create a new gRPC request.
2. Server URL: `{{grpc_host}}`
3. Import proto: `driver-location/protos/nearby_drivers.proto`
4. Select method: `DriverLocation.DriverLocation/FindNearByDrivers`
5. Send JSON payload.

### Testing via grpcurl

```bash
grpcurl -plaintext \
  -import-path driver-location/protos \
  -proto nearby_drivers.proto \
  -d '{"pickUpLongitude":"72.5714","pickUpLatitude":"23.0225","radius":"5"}' \
  {{grpc_host}} \
  DriverLocation.DriverLocation/FindNearByDrivers
```

---

## WebSocket Documentation

Socket server: `{{socket_url}}/ws/request-trip`

Authentication:

- Query token: `ws://.../ws/request-trip?token=<accessToken>`
- Or Authorization header bearer token in WS upgrade request.

Message envelope:

```json
{
  "event": "trip.request | trip.accept",
  "requestId": "optional-string",
  "data": {}
}
```

Server error envelope:

```json
{
  "event": "error",
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "validation error",
    "details": []
  },
  "meta": { "requestId": "uuid" }
}
```

### Server Event: connection.ready

- Description: Sent immediately after successful socket authentication.
- Payload:

```json
{
  "event": "connection.ready",
  "data": {
    "userId": "uuid",
    "role": "rider | driver",
    "path": "/ws/request-trip"
  },
  "meta": { "requestId": "uuid" }
}
```

### Client Event: trip.request

- Description: Rider requests a ride.
- Emit payload:

```json
{
  "event": "trip.request",
  "requestId": "uuid",
  "data": {
    "pickupLongitude": "72.5714",
    "pickupLatitude": "23.0225",
    "dropoffLongitude": "72.6120",
    "dropoffLatitude": "23.0456"
  }
}
```

- Server emits:
  - `trip.requested` to rider
  - `trip.request.available` to each nearby connected driver

### Server Event: trip.requested

- Description: Confirms request creation to rider.
- Payload:

```json
{
  "event": "trip.requested",
  "data": {
    "tripRequestId": "uuid",
    "nearbyDriverCount": 2,
    "status": "requested"
  },
  "meta": { "requestId": "uuid" }
}
```

### Server Event: trip.request.available

- Description: Broadcast to eligible nearby drivers.
- Payload:

```json
{
  "event": "trip.request.available",
  "data": {
    "tripRequestId": "uuid",
    "pickupLocation": { "longitude": "72.5714", "latitude": "23.0225" },
    "dropoffLocation": { "longitude": "72.6120", "latitude": "23.0456" },
    "status": "requested",
    "requestedAt": "2026-03-25T12:00:00.000Z"
  },
  "meta": { "requestId": "uuid" }
}
```

### Client Event: trip.accept

- Description: Driver accepts ride request.
- Emit payload:

```json
{
  "event": "trip.accept",
  "requestId": "uuid",
  "data": {
    "tripRequestId": "uuid"
  }
}
```

- Server emits:
  - `trip.accepted` to driver
  - `trip.accepted` to rider

### Server Event: trip.accepted

- Description: Active trip confirmation.
- Payload:

```json
{
  "event": "trip.accepted",
  "data": {
    "tripRequestId": "uuid",
    "riderId": "uuid",
    "driverId": "uuid",
    "pickupLocation": { "longitude": "72.5714", "latitude": "23.0225" },
    "dropoffLocation": { "longitude": "72.6120", "latitude": "23.0456" },
    "status": "active",
    "requestedAt": "2026-03-25T12:00:00.000Z",
    "acceptedAt": "2026-03-25T12:00:12.000Z"
  },
  "meta": { "requestId": "uuid" }
}
```

### WebSocket Error Cases

- `INVALID_JSON`: non-JSON payload.
- `VALIDATION_ERROR`: malformed event envelope or event data.
- `FORBIDDEN`: rider tried `trip.accept` or driver tried `trip.request`.
- `TRIP_NOT_AVAILABLE`: trip already accepted / not found / driver not eligible.
- `DRIVER_LOCATION_UNAVAILABLE`: gRPC driver-location service unavailable.
- `INTERNAL_SERVER_ERROR`: unhandled exception.
