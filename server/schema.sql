-- Custom types for enums
CREATE TYPE gender AS ENUM ('male', 'female', 'other');
CREATE TYPE onboarding_status AS ENUM ('info_remaining', 'documents_uploaded', 'approved', 'rejected');

-- Rider table
CREATE TABLE rider (
    rider_id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    phone_no TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    email TEXT,
    photo_link TEXT,
    gender gender
);

-- Driver table
CREATE TABLE driver (
    driver_id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
    phone_no TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    email TEXT,
    photo_link TEXT,
    gender gender,
    residentail_address TEXT,
    vehical_type TEXT,
    vehical_registration_no TEXT,
    passenger_capacity INTEGER,
    vehical_photo TEXT,
    driving_license_photo TEXT,
    vehical_rc_photo TEXT,
    onboarding_status onboarding_status DEFAULT 'info_remaining'
);

-- Indexes for performance (based on common query patterns like lookups by email or phone)
CREATE INDEX idx_rider_email ON rider (email);
CREATE INDEX idx_rider_phone_no ON rider (phone_no);
CREATE INDEX idx_driver_email ON driver (email);
CREATE INDEX idx_driver_phone_no ON driver (phone_no);
CREATE INDEX idx_driver_onboarding_status ON driver (onboarding_status);