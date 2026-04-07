import 'package:equatable/equatable.dart';

enum DriverOnboardingStatus {
  approved,
  documentsUploaded,
  infoRemaining,
  rejected,
  unknown,
}

class DriverSession extends Equatable {
  const DriverSession({
    required this.userId,
    required this.phoneNumber,
    required this.accessToken,
    required this.refreshToken,
    required this.onboardingStatus,
    required this.isNewUser,
  });

  final String userId;
  final String phoneNumber;
  final String accessToken;
  final String refreshToken;
  final DriverOnboardingStatus onboardingStatus;
  final bool isNewUser;

  bool get isApproved => onboardingStatus == DriverOnboardingStatus.approved;

  DriverSession copyWith({
    String? userId,
    String? phoneNumber,
    String? accessToken,
    String? refreshToken,
    DriverOnboardingStatus? onboardingStatus,
    bool? isNewUser,
  }) {
    return DriverSession(
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      onboardingStatus: onboardingStatus ?? this.onboardingStatus,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    userId,
    phoneNumber,
    accessToken,
    refreshToken,
    onboardingStatus,
    isNewUser,
  ];
}
