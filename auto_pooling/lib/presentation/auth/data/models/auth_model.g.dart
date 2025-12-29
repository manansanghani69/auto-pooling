// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpRequestModel _$OtpRequestModelFromJson(Map<String, dynamic> json) =>
    OtpRequestModel(
      ok: json['ok'] as bool? ?? false,
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$OtpRequestModelToJson(OtpRequestModel instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'expiresIn': instance.expiresIn,
    };

AuthUserModel _$AuthUserModelFromJson(Map<String, dynamic> json) =>
    AuthUserModel(
      id: json['id'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      createdAt: AuthUserModel._dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$AuthUserModelToJson(AuthUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'role': instance.role,
      'created_at': AuthUserModel._dateTimeToJson(instance.createdAt),
    };

AuthTokensModel _$AuthTokensModelFromJson(Map<String, dynamic> json) =>
    AuthTokensModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresIn: json['expiresIn'] as String? ?? '',
    );

Map<String, dynamic> _$AuthTokensModelToJson(AuthTokensModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };

VerifyOtpModel _$VerifyOtpModelFromJson(Map<String, dynamic> json) =>
    VerifyOtpModel(
      user: VerifyOtpModel._userFromJson(json['user']),
      tokens: VerifyOtpModel._tokensFromJson(json['tokens']),
      isNewUser: json['isNewUser'] as bool? ?? false,
    );

Map<String, dynamic> _$VerifyOtpModelToJson(VerifyOtpModel instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'tokens': instance.tokens.toJson(),
      'isNewUser': instance.isNewUser,
    };

LogoutModel _$LogoutModelFromJson(Map<String, dynamic> json) => LogoutModel(
      ok: json['ok'] as bool? ?? false,
    );

Map<String, dynamic> _$LogoutModelToJson(LogoutModel instance) =>
    <String, dynamic>{
      'ok': instance.ok,
    };
