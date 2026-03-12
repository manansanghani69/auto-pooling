// src/profile/controller.js
import * as profileService from './service.js';
import { USER_ROLES, normalizeRole } from '../common/userColumns.js';

const ALLOWED_GENDERS = new Set(['male', 'female', 'other']);
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const MAX_URL_LENGTH = 2048;
const MAX_PASSENGER_CAPACITY = 20;

function toTrimmedString(value) {
  if (value === undefined || value === null) return '';
  return String(value).trim();
}

function toOptionalTrimmedString(value) {
  const trimmed = toTrimmedString(value);
  return trimmed ? trimmed : undefined;
}

function toOptionalPositiveInteger(value) {
  if (value === undefined || value === null || value === '') return undefined;
  const parsed = Number(value);
  if (!Number.isInteger(parsed) || parsed <= 0) return null;
  return parsed;
}

function pickField(body, keys) {
  if (!body || typeof body !== 'object') return undefined;
  for (const key of keys) {
    if (Object.hasOwn(body, key)) return body[key];
  }
  return undefined;
}

function hasAnyField(body, keys) {
  if (!body || typeof body !== 'object') return false;
  return keys.some((key) => Object.hasOwn(body, key));
}

function sendError(res, status, message) {
  return res.status(status).json({
    status: 'error',
    code: status,
    data: null,
    error: { message },
  });
}

function sendServerError(res, error) {
  console.error(error);
  return res.status(500).json({
    status: 'error',
    code: 500,
    data: null,
    error: { message: 'server error' },
  });
}

function sanitizeUser(user) {
  if (!user) return user;
  const { password: _password, ...safeUser } = user;
  return safeUser;
}

function sendSuccess(res, status, data) {
  return res.status(status).json({
    status: 'success',
    code: status,
    data,
  });
}

function getAuthContext(req, res, expectedRole) {
  const userId = toOptionalTrimmedString(req.user?.sub);
  const role = normalizeRole(req.user?.role);

  if (!userId || !role) {
    sendError(res, 401, 'unauthorized');
    return null;
  }

  if (expectedRole && role !== expectedRole) {
    sendError(res, 403, 'forbidden');
    return null;
  }

  return { userId, role };
}

function parseOptionalStringField(rawValue, fieldName, maxLength = 255) {
  const value = toOptionalTrimmedString(rawValue);
  if (value === undefined) return { value: undefined };
  if (value.length > maxLength) {
    return { error: `${fieldName} is too long` };
  }
  return { value };
}

function parseOptionalHttpUrl(rawValue, fieldName) {
  const parsed = parseOptionalStringField(rawValue, fieldName, MAX_URL_LENGTH);
  if (parsed.error || parsed.value === undefined) return parsed;

  try {
    const url = new URL(parsed.value);
    if (url.protocol !== 'http:' && url.protocol !== 'https:') {
      return { error: `${fieldName} must be a valid http/https URL` };
    }
  } catch {
    return { error: `${fieldName} must be a valid URL` };
  }

  return parsed;
}

function parseCommonProfileFields(body) {
  const updates = {};

  const nameParsed = parseOptionalStringField(body.name, 'name', 120);
  if (nameParsed.error) return nameParsed;
  if (nameParsed.value !== undefined) updates.name = nameParsed.value;

  const emailParsed = parseOptionalStringField(body.email, 'email', 254);
  if (emailParsed.error) return emailParsed;
  if (emailParsed.value !== undefined) {
    if (!EMAIL_REGEX.test(emailParsed.value)) {
      return { error: 'email must be a valid email address' };
    }
    updates.email = emailParsed.value.toLowerCase();
  }

  const photoParsed = parseOptionalHttpUrl(
    pickField(body, ['photoLink', 'photo_link', 'profile_photo']),
    'photo_link'
  );
  if (photoParsed.error) return photoParsed;
  if (photoParsed.value !== undefined) updates.photoLink = photoParsed.value;

  const genderParsed = parseOptionalStringField(body.gender, 'gender', 16);
  if (genderParsed.error) return genderParsed;
  if (genderParsed.value !== undefined) {
    const normalizedGender = genderParsed.value.toLowerCase();
    if (!ALLOWED_GENDERS.has(normalizedGender)) {
      return { error: 'gender must be one of male, female, other' };
    }
    updates.gender = normalizedGender;
  }

  return { updates };
}

function parseRiderProfileFields(body) {
  return parseCommonProfileFields(body);
}

function parseDriverProfileFields(body, options = {}) {
  const { allowDocuments = true } = options;
  const commonParsed = parseCommonProfileFields(body);
  if (commonParsed.error) return commonParsed;

  const updates = commonParsed.updates;
  if (hasAnyField(body, ['onboarding_status'])) {
    return {
      error:
        'onboarding_status cannot be set directly. Use /v1/profile/driver/verify-document endpoint.',
    };
  }

  const addressParsed = parseOptionalStringField(
    pickField(body, ['residentail_address', 'residential_address']),
    'residentail_address',
    500
  );
  if (addressParsed.error) return addressParsed;
  if (addressParsed.value !== undefined) updates.residentailAddress = addressParsed.value;

  const typeParsed = parseOptionalStringField(
    pickField(body, ['vehical_type', 'vehicle_type']),
    'vehical_type',
    120
  );
  if (typeParsed.error) return typeParsed;
  if (typeParsed.value !== undefined) updates.vehicalType = typeParsed.value;

  const regParsed = parseOptionalStringField(
    pickField(body, ['vehical_registration_no', 'vehicle_registration_no']),
    'vehical_registration_no',
    60
  );
  if (regParsed.error) return regParsed;
  if (regParsed.value !== undefined) updates.vehicalRegistrationNo = regParsed.value.toUpperCase();

  const passengerCapacity = toOptionalPositiveInteger(body.passenger_capacity);
  if (passengerCapacity === null) {
    return { error: 'passenger_capacity must be a positive integer' };
  }
  if (passengerCapacity !== undefined) {
    if (passengerCapacity > MAX_PASSENGER_CAPACITY) {
      return { error: `passenger_capacity cannot be greater than ${MAX_PASSENGER_CAPACITY}` };
    }
    updates.passengerCapacity = passengerCapacity;
  }

  if (allowDocuments) {
    const vehiclePhotoParsed = parseOptionalHttpUrl(
      pickField(body, ['vehical_photo', 'vehicle_photo']),
      'vehical_photo'
    );
    if (vehiclePhotoParsed.error) return vehiclePhotoParsed;
    if (vehiclePhotoParsed.value !== undefined) updates.vehicalPhoto = vehiclePhotoParsed.value;

    const licensePhotoParsed = parseOptionalHttpUrl(body.driving_license_photo, 'driving_license_photo');
    if (licensePhotoParsed.error) return licensePhotoParsed;
    if (licensePhotoParsed.value !== undefined) {
      updates.drivingLicensePhoto = licensePhotoParsed.value;
    }

    const rcPhotoParsed = parseOptionalHttpUrl(
      pickField(body, ['vehical_rc_photo', 'vehicle_rc_photo']),
      'vehical_rc_photo'
    );
    if (rcPhotoParsed.error) return rcPhotoParsed;
    if (rcPhotoParsed.value !== undefined) updates.vehicalRcPhoto = rcPhotoParsed.value;
  }

  return { updates };
}

function parseDriverDocumentFields(body) {
  if (hasAnyField(body, ['onboarding_status'])) {
    return { error: 'onboarding_status cannot be set directly' };
  }

  const vehiclePhotoParsed = parseOptionalHttpUrl(
    pickField(body, ['vehical_photo', 'vehicle_photo']),
    'vehical_photo'
  );
  if (vehiclePhotoParsed.error) return vehiclePhotoParsed;

  const licensePhotoParsed = parseOptionalHttpUrl(body.driving_license_photo, 'driving_license_photo');
  if (licensePhotoParsed.error) return licensePhotoParsed;

  const rcPhotoParsed = parseOptionalHttpUrl(
    pickField(body, ['vehical_rc_photo', 'vehicle_rc_photo']),
    'vehical_rc_photo'
  );
  if (rcPhotoParsed.error) return rcPhotoParsed;

  const updates = {};
  if (vehiclePhotoParsed.value !== undefined) updates.vehicalPhoto = vehiclePhotoParsed.value;
  if (licensePhotoParsed.value !== undefined) updates.drivingLicensePhoto = licensePhotoParsed.value;
  if (rcPhotoParsed.value !== undefined) updates.vehicalRcPhoto = rcPhotoParsed.value;

  const requiredDocs = ['vehicalPhoto', 'drivingLicensePhoto', 'vehicalRcPhoto'];
  const missingDocs = requiredDocs.filter((field) => updates[field] === undefined);
  if (missingDocs.length) {
    return {
      error: 'vehical_photo, driving_license_photo and vehical_rc_photo are required',
    };
  }

  updates.onboardingStatus = 'documents_uploaded';
  return { updates };
}

function getMissingRequiredFields(updates, required) {
  return required.filter((field) => updates[field.key] === undefined).map((field) => field.label);
}

async function saveProfileUpdates(res, auth, updates, successStatus = 200) {
  if (!Object.keys(updates).length) {
    return sendError(res, 400, 'no profile fields provided');
  }

  const user = await profileService.updateUserProfile(auth.userId, auth.role, updates);
  if (!user) return sendError(res, 404, 'user not found');
  return sendSuccess(res, successStatus, { user: sanitizeUser(user) });
}

export async function createRiderUser(req, res) {
  try {
    const auth = getAuthContext(req, res, USER_ROLES.RIDER);
    if (!auth) return;

    const parsed = parseRiderProfileFields(req.body ?? {});
    if (parsed.error) return sendError(res, 400, parsed.error);

    const missingFields = getMissingRequiredFields(parsed.updates, [{ key: 'name', label: 'name' }]);
    if (missingFields.length) {
      return sendError(res, 400, `missing required field(s): ${missingFields.join(', ')}`);
    }

    return saveProfileUpdates(res, auth, parsed.updates, 200);
  } catch (e) {
    return sendServerError(res, e);
  }
}

export async function editRiderUser(req, res) {
  try {
    const auth = getAuthContext(req, res, USER_ROLES.RIDER);
    if (!auth) return;

    const parsed = parseRiderProfileFields(req.body ?? {});
    if (parsed.error) return sendError(res, 400, parsed.error);
    return saveProfileUpdates(res, auth, parsed.updates, 200);
  } catch (e) {
    return sendServerError(res, e);
  }
}

export async function createDriverUser(req, res) {
  try {
    const auth = getAuthContext(req, res, USER_ROLES.DRIVER);
    if (!auth) return;

    const parsed = parseDriverProfileFields(req.body ?? {});
    if (parsed.error) return sendError(res, 400, parsed.error);

    const missingFields = getMissingRequiredFields(parsed.updates, [
      { key: 'name', label: 'name' },
      { key: 'residentailAddress', label: 'residentail_address' },
      { key: 'vehicalType', label: 'vehical_type' },
      { key: 'vehicalRegistrationNo', label: 'vehical_registration_no' },
      { key: 'passengerCapacity', label: 'passenger_capacity' },
    ]);
    if (missingFields.length) {
      return sendError(res, 400, `missing required field(s): ${missingFields.join(', ')}`);
    }

    return saveProfileUpdates(res, auth, parsed.updates, 200);
  } catch (e) {
    return sendServerError(res, e);
  }
}

export async function editDriverUser(req, res) {
  try {
    const auth = getAuthContext(req, res, USER_ROLES.DRIVER);
    if (!auth) return;

    const parsed = parseDriverProfileFields(req.body ?? {});
    if (parsed.error) return sendError(res, 400, parsed.error);
    return saveProfileUpdates(res, auth, parsed.updates, 200);
  } catch (e) {
    return sendServerError(res, e);
  }
}

export async function verifyDriverDocument(req, res) {
  try {
    const auth = getAuthContext(req, res, USER_ROLES.DRIVER);
    if (!auth) return;

    const parsed = parseDriverDocumentFields(req.body ?? {});
    if (parsed.error) return sendError(res, 400, parsed.error);
    return saveProfileUpdates(res, auth, parsed.updates, 200);
  } catch (e) {
    return sendServerError(res, e);
  }
}

export async function updateProfile(req, res) {
  const role = normalizeRole(req.user?.role);
  if (role === USER_ROLES.RIDER) return editRiderUser(req, res);
  if (role === USER_ROLES.DRIVER) return editDriverUser(req, res);
  return sendError(res, 401, 'unauthorized');
}

export async function profile(req, res) {
  try {
    const auth = getAuthContext(req, res);
    if (!auth) return;

    const user = await profileService.findUserById(auth.userId, auth.role);
    if (!user) return sendError(res, 404, 'user not found');
    return sendSuccess(res, 200, { user: sanitizeUser(user) });
  } catch (e) {
    return sendServerError(res, e);
  }
}
