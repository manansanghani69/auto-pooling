CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS rider (
  rider_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  phone_no VARCHAR(20) UNIQUE NOT NULL,
  name TEXT,
  email TEXT,
  photo_link TEXT,
  gender TEXT CHECK (gender IN ('male', 'female', 'other'))
);

CREATE TABLE IF NOT EXISTS driver (
  driver_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  phone_no VARCHAR(20) UNIQUE NOT NULL,
  name TEXT,
  email TEXT,
  photo_link TEXT,
  gender TEXT CHECK (gender IN ('male', 'female', 'other')),
  residentail_address TEXT,
  vehical_type TEXT,
  vehical_registration_no TEXT,
  passenger_capacity INTEGER,
  vehical_photo TEXT,
  driving_license_photo TEXT,
  vehical_rc_photo TEXT,
  onboarding_status TEXT
    CHECK (onboarding_status IN ('info_remaining', 'documents_uploaded', 'approved', 'rejected'))
    DEFAULT 'info_remaining'
);

CREATE TABLE IF NOT EXISTS driver_coordinates (
  driver_id UUID NOT NULL,
  location TEXT NOT NULL,
  PRIMARY KEY (driver_id, location),
  FOREIGN KEY (driver_id) REFERENCES driver(driver_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS active_trips (
  trip_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  rider_id UUID NOT NULL,
  driver_id UUID NOT NULL,
  fare TEXT,
  start_location TEXT,
  end_location TEXT,
  status TEXT CHECK (status IN ('active', 'ended', 'cancled')) DEFAULT 'active',
  FOREIGN KEY (rider_id) REFERENCES rider(rider_id) ON DELETE CASCADE,
  FOREIGN KEY (driver_id) REFERENCES driver(driver_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS active_requested_trips (
  request_id UUID NOT NULL DEFAULT uuid_generate_v4(),
  trip_id UUID NOT NULL,
  rider_id UUID NOT NULL,
  rider_location TEXT,
  vehical_type TEXT,
  fare TEXT,
  start_location TEXT,
  end_location TEXT,
  status TEXT CHECK (status IN ('searching', 'accepted', 'closed')) DEFAULT 'searching',
  PRIMARY KEY (request_id, trip_id),
  FOREIGN KEY (trip_id) REFERENCES active_trips(trip_id) ON DELETE CASCADE,
  FOREIGN KEY (rider_id) REFERENCES rider(rider_id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_active_requested_trips_trip_id
  ON active_requested_trips (trip_id);
