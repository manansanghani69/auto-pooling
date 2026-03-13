import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/profile_entity.dart';

part 'profile_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfileResponseModel {
  @JsonKey(fromJson: _userFromJson)
  final ProfileUserModel user;

  const ProfileResponseModel({required this.user});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseModelToJson(this);

  static ProfileUserModel _userFromJson(Object? value) {
    if (value is Map<String, dynamic>) {
      return ProfileUserModel.fromJson(value);
    }
    return const ProfileUserModel(
      id: '',
      phone: '',
      name: '',
      email: null,
      profilePhoto: null,
      gender: null,
      role: '',
      createdAt: null,
    );
  }
}

@JsonSerializable()
class ProfileUserModel {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String phone;
  @JsonKey(defaultValue: '')
  final String name;
  final String? email;
  @JsonKey(name: 'profile_photo')
  final String? profilePhoto;
  final String? gender;
  @JsonKey(defaultValue: '')
  final String role;
  @JsonKey(
    name: 'created_at',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
  )
  final DateTime? createdAt;

  const ProfileUserModel({
    required this.id,
    required this.phone,
    required this.name,
    required this.email,
    required this.profilePhoto,
    required this.gender,
    required this.role,
    required this.createdAt,
  });

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileUserModelToJson(this);

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      phone: phone,
      name: name,
      email: email,
      profilePhoto: profilePhoto,
      gender: gender,
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
