class OtpRequestEntity {
  final bool ok;
  final int expiresIn;

  const OtpRequestEntity({
    required this.ok,
    required this.expiresIn,
  });
}

class AuthUserEntity {
  final String id;
  final String phone;
  final String name;
  final String role;
  final DateTime? createdAt;

  const AuthUserEntity({
    required this.id,
    required this.phone,
    required this.name,
    required this.role,
    required this.createdAt,
  });
}

class AuthTokensEntity {
  final String accessToken;
  final String refreshToken;
  final String expiresIn;

  const AuthTokensEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });
}

class VerifyOtpEntity {
  final AuthUserEntity user;
  final AuthTokensEntity tokens;
  final bool isNewUser;

  const VerifyOtpEntity({
    required this.user,
    required this.tokens,
    required this.isNewUser,
  });
}

class LogoutEntity {
  final bool ok;

  const LogoutEntity({
    required this.ok,
  });
}
