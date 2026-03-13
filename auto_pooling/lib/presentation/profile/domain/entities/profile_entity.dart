class ProfileEntity {
  final String id;
  final String phone;
  final String name;
  final String? email;
  final String? profilePhoto;
  final String? gender;
  final String role;
  final DateTime? createdAt;

  const ProfileEntity({
    required this.id,
    required this.phone,
    required this.name,
    required this.email,
    required this.profilePhoto,
    required this.gender,
    required this.role,
    required this.createdAt,
  });
}
