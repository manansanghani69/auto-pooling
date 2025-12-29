import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/auth_entity.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class OtpRequestModel {
  @JsonKey(defaultValue: false)
  final bool ok;
  @JsonKey(defaultValue: 0)
  final int expiresIn;

  const OtpRequestModel({
    required this.ok,
    required this.expiresIn,
  });

  factory OtpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpRequestModelToJson(this);

  OtpRequestEntity toEntity() {
    return OtpRequestEntity(
      ok: ok,
      expiresIn: expiresIn,
    );
  }
}

@JsonSerializable()
class AuthUserModel {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String phone;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String role;
  @JsonKey(
    name: 'created_at',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
  )
  final DateTime? createdAt;

  const AuthUserModel({
    required this.id,
    required this.phone,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  AuthUserEntity toEntity() {
    return AuthUserEntity(
      id: id,
      phone: phone,
      name: name,
      role: role,
      createdAt: createdAt,
    );
  }

  static DateTime? _dateTimeFromJson(Object? value) {
    if (value == null) {
      return null;
    }
    return DateTime.tryParse(value.toString());
  }

  static Object? _dateTimeToJson(DateTime? value) => value?.toIso8601String();
}

@JsonSerializable()
class AuthTokensModel {
  @JsonKey(defaultValue: '')
  final String accessToken;
  @JsonKey(defaultValue: '')
  final String refreshToken;
  @JsonKey(defaultValue: '')
  final String expiresIn;

  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokensModelToJson(this);

  AuthTokensEntity toEntity() {
    return AuthTokensEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class VerifyOtpModel {
  @JsonKey(fromJson: _userFromJson)
  final AuthUserModel user;
  @JsonKey(fromJson: _tokensFromJson)
  final AuthTokensModel tokens;
  @JsonKey(defaultValue: false)
  final bool isNewUser;

  const VerifyOtpModel({
    required this.user,
    required this.tokens,
    required this.isNewUser,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpModelToJson(this);

  VerifyOtpEntity toEntity() {
    return VerifyOtpEntity(
      user: user.toEntity(),
      tokens: tokens.toEntity(),
      isNewUser: isNewUser,
    );
  }

  static AuthUserModel _userFromJson(Object? value) {
    if (value is Map<String, dynamic>) {
      return AuthUserModel.fromJson(value);
    }
    return const AuthUserModel(
      id: '',
      phone: '',
      name: '',
      role: '',
      createdAt: null,
    );
  }

  static AuthTokensModel _tokensFromJson(Object? value) {
    if (value is Map<String, dynamic>) {
      return AuthTokensModel.fromJson(value);
    }
    return const AuthTokensModel(
      accessToken: '',
      refreshToken: '',
      expiresIn: '',
    );
  }
}

@JsonSerializable()
class LogoutModel {
  @JsonKey(defaultValue: false)
  final bool ok;

  const LogoutModel({
    required this.ok,
  });

  factory LogoutModel.fromJson(Map<String, dynamic> json) =>
      _$LogoutModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutModelToJson(this);

  LogoutEntity toEntity() {
    return LogoutEntity(ok: ok);
  }
}
