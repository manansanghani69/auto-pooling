import 'package:equatable/equatable.dart';

class VerifiedDriverAuthModel extends Equatable {
  const VerifiedDriverAuthModel({
    required this.userId,
    required this.phoneNumber,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
    required this.isNewUser,
  });

  final String userId;
  final String phoneNumber;
  final String role;
  final String accessToken;
  final String refreshToken;
  final bool isNewUser;

  factory VerifiedDriverAuthModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> user =
        data['user'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> tokens =
        data['tokens'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return VerifiedDriverAuthModel(
      userId: user['id']?.toString() ?? '',
      phoneNumber:
          user['phone_no']?.toString() ?? user['phone']?.toString() ?? '',
      role: user['role']?.toString() ?? '',
      accessToken: tokens['accessToken']?.toString() ?? '',
      refreshToken: tokens['refreshToken']?.toString() ?? '',
      isNewUser: data['isNewUser'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    userId,
    phoneNumber,
    role,
    accessToken,
    refreshToken,
    isNewUser,
  ];
}
