export const USER_ROLES = Object.freeze({
  RIDER: 'rider',
  DRIVER: 'driver',
});

export const USER_LOOKUP_ORDER = Object.freeze([
  USER_ROLES.RIDER,
  USER_ROLES.DRIVER,
]);

const RIDER_SAFE_COLUMNS = [
  'rider_id AS id',
  'rider_id',
  `'rider'::text AS role`,
  'phone_no',
  'name',
  'email',
  'photo_link',
  'gender',
].join(', ');

const DRIVER_SAFE_COLUMNS = [
  'driver_id AS id',
  'driver_id',
  `'driver'::text AS role`,
  'phone_no',
  'name',
  'email',
  'photo_link',
  'gender',
  'residentail_address',
  'vehical_type',
  'vehical_registration_no',
  'passenger_capacity',
  'vehical_photo',
  'driving_license_photo',
  'vehical_rc_photo',
  'onboarding_status',
].join(', ');

const TABLE_BY_ROLE = Object.freeze({
  [USER_ROLES.RIDER]: 'rider',
  [USER_ROLES.DRIVER]: 'driver',
});

const ID_COLUMN_BY_ROLE = Object.freeze({
  [USER_ROLES.RIDER]: 'rider_id',
  [USER_ROLES.DRIVER]: 'driver_id',
});

const SAFE_COLUMNS_BY_ROLE = Object.freeze({
  [USER_ROLES.RIDER]: RIDER_SAFE_COLUMNS,
  [USER_ROLES.DRIVER]: DRIVER_SAFE_COLUMNS,
});

export function normalizeRole(role) {
  const normalized = String(role ?? '').trim().toLowerCase();
  if (normalized === USER_ROLES.RIDER || normalized === USER_ROLES.DRIVER) {
    return normalized;
  }
  return null;
}

export function isSupportedRole(role) {
  return normalizeRole(role) !== null;
}

export function getUserTableByRole(role) {
  const normalizedRole = normalizeRole(role);
  if (!normalizedRole) throw new Error('Unsupported role');
  return TABLE_BY_ROLE[normalizedRole];
}

export function getUserIdColumnByRole(role) {
  const normalizedRole = normalizeRole(role);
  if (!normalizedRole) throw new Error('Unsupported role');
  return ID_COLUMN_BY_ROLE[normalizedRole];
}

export function getUserSafeColumnsByRole(role) {
  const normalizedRole = normalizeRole(role);
  if (!normalizedRole) throw new Error('Unsupported role');
  return SAFE_COLUMNS_BY_ROLE[normalizedRole];
}
