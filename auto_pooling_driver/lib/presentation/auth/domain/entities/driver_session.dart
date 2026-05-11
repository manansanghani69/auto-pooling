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
    required this.hasCompletedProfileDetails,
  });

  final String userId;
  final String phoneNumber;
  final String accessToken;
  final String refreshToken;
  final DriverOnboardingStatus onboardingStatus;
  final bool isNewUser;
  final bool hasCompletedProfileDetails;

  bool get isApproved => onboardingStatus == DriverOnboardingStatus.approved;

  bool get hasCompletedOnboarding => isApproved;

  bool get hasSubmittedDocuments =>
      onboardingStatus == DriverOnboardingStatus.documentsUploaded ||
      onboardingStatus == DriverOnboardingStatus.approved;

  DriverSession copyWith({
    String? userId,
    String? phoneNumber,
    String? accessToken,
    String? refreshToken,
    DriverOnboardingStatus? onboardingStatus,
    bool? isNewUser,
    bool? hasCompletedProfileDetails,
  }) {
    return DriverSession(
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      onboardingStatus: onboardingStatus ?? this.onboardingStatus,
      isNewUser: isNewUser ?? this.isNewUser,
      hasCompletedProfileDetails:
          hasCompletedProfileDetails ?? this.hasCompletedProfileDetails,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'phoneNumber': phoneNumber,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'onboardingStatus': onboardingStatus.name,
      'isNewUser': isNewUser,
      'hasCompletedProfileDetails': hasCompletedProfileDetails,
    };
  }

  factory DriverSession.fromJson(Map<String, dynamic> json) {
    return DriverSession(
      userId: json['userId']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      onboardingStatus: DriverOnboardingStatus.values.firstWhere(
        (DriverOnboardingStatus status) =>
            status.name == json['onboardingStatus']?.toString(),
        orElse: () => DriverOnboardingStatus.unknown,
      ),
      isNewUser: json['isNewUser'] as bool? ?? false,
      hasCompletedProfileDetails:
          json['hasCompletedProfileDetails'] as bool? ?? false,
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
    hasCompletedProfileDetails,
  ];
}
