import { pool } from '../common/db.js';
import {
  USER_LOOKUP_ORDER,
  USER_ROLES,
  getUserIdColumnByRole,
  getUserSafeColumnsByRole,
  getUserTableByRole,
  normalizeRole,
} from '../common/userColumns.js';

const COMMON_UPDATE_FIELD_MAP = Object.freeze({
  name: 'name',
  email: 'email',
  photoLink: 'photo_link',
  gender: 'gender',
});

const DRIVER_UPDATE_FIELD_MAP = Object.freeze({
  residentailAddress: 'residentail_address',
  vehicalType: 'vehical_type',
  vehicalRegistrationNo: 'vehical_registration_no',
  passengerCapacity: 'passenger_capacity',
  vehicalPhoto: 'vehical_photo',
  drivingLicensePhoto: 'driving_license_photo',
  vehicalRcPhoto: 'vehical_rc_photo',
  onboardingStatus: 'onboarding_status',
});

function getUpdateFieldMap(role) {
  if (role === USER_ROLES.DRIVER) {
    return { ...COMMON_UPDATE_FIELD_MAP, ...DRIVER_UPDATE_FIELD_MAP };
  }
  return COMMON_UPDATE_FIELD_MAP;
}

async function findUserByIdAndRole(userId, role) {
  const table = getUserTableByRole(role);
  const idColumn = getUserIdColumnByRole(role);
  const safeColumns = getUserSafeColumnsByRole(role);

  const sql = `SELECT ${safeColumns} FROM ${table} WHERE ${idColumn}=$1`;
  const res = await pool.query(sql, [userId]);
  return res.rows[0] ?? null;
}

export async function findUserById(userId, role) {
  const normalizedRole = normalizeRole(role);

  if (normalizedRole) {
    return findUserByIdAndRole(userId, normalizedRole);
  }

  for (const candidateRole of USER_LOOKUP_ORDER) {
    const user = await findUserByIdAndRole(userId, candidateRole);
    if (user) return user;
  }

  return null;
}

export async function updateUserProfile(userId, role, updates) {
  const normalizedRole = normalizeRole(role);
  if (!normalizedRole) return null;

  const table = getUserTableByRole(normalizedRole);
  const idColumn = getUserIdColumnByRole(normalizedRole);
  const safeColumns = getUserSafeColumnsByRole(normalizedRole);
  const updateFieldMap = getUpdateFieldMap(normalizedRole);

  const fields = [];
  const values = [];
  let index = 1;

  for (const [key, value] of Object.entries(updates)) {
    const column = updateFieldMap[key];
    if (!column || value === undefined) continue;
    fields.push(`${column}=$${index++}`);
    values.push(value);
  }

  if (!fields.length) return null;

  values.push(userId);
  const sql = `UPDATE ${table} SET ${fields.join(', ')} WHERE ${idColumn}=$${index} RETURNING ${safeColumns}`;
  const res = await pool.query(sql, values);
  return res.rows[0] ?? null;
}
