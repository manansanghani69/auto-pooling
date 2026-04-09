export function resolveApiServiceUrl(pathname, serviceUrls) {
  if (pathname.startsWith('/v1/auth')) return serviceUrls.auth;
  if (pathname.startsWith('/v1/profile')) return serviceUrls.profile;
  if (pathname.startsWith('/v1/driver-location')) return serviceUrls.driverLocation;
  return null;
}

export function forwardApiRoute(options) {
  const { pathname, req, res, serviceUrls, forwardRequest } = options;
  const target = resolveApiServiceUrl(pathname, serviceUrls);
  if (!target) return false;

  forwardRequest(req, res, target);
  return true;
}
