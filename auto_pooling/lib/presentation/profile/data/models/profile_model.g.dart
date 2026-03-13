// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponseModel _$ProfileResponseModelFromJson(
        Map<String, dynamic> json) =>
    ProfileResponseModel(
      user: ProfileResponseModel._userFromJson(json['user']),
    );

Map<String, dynamic> _$ProfileResponseModelToJson(
        ProfileResponseModel instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
    };

ProfileUserModel _$ProfileUserModelFromJson(Map<String, dynamic> json) =>
    ProfileUserModel(
      id: json['id'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      profilePhoto: json['profile_photo'] as String?,
      gender: json['gender'] as String?,
      role: json['role'] as String? ?? '',
      createdAt: ProfileUserModel._dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$ProfileUserModelToJson(ProfileUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'email': instance.email,
      'profile_photo': instance.profilePhoto,
      'gender': instance.gender,
      'role': instance.role,
      'created_at': ProfileUserModel._dateTimeToJson(instance.createdAt),
    };
