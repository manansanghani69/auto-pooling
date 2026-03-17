export const USER_ROLES = Object.freeze({
  RIDER: 'rider',
  DRIVER: 'driver',
});

export function normalizeRole(role) {
  const normalized = String(role ?? '').trim().toLowerCase();
  if (normalized === USER_ROLES.RIDER || normalized === USER_ROLES.DRIVER) {
    return normalized;
  }
  return null;
}
