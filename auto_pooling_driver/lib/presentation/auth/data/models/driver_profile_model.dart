import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:equatable/equatable.dart';

class DriverProfileModel extends Equatable {
  const DriverProfileModel({required this.onboardingStatus});

  final DriverOnboardingStatus onboardingStatus;

  factory DriverProfileModel.fromJson(
    Map<String, dynamic> json, {
    required bool isNewUser,
  }) {
    final Map<String, dynamic> data =
        json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> user =
        data['user'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final String? onboardingStatus = user['onboarding_status']?.toString();

    return DriverProfileModel(
      onboardingStatus: _resolveStatus(onboardingStatus, isNewUser: isNewUser),
    );
  }

  static DriverOnboardingStatus _resolveStatus(
    String? rawStatus, {
    required bool isNewUser,
  }) {
    switch (rawStatus) {
      case 'approved':
        return DriverOnboardingStatus.approved;
      case 'documents_uploaded':
        return DriverOnboardingStatus.documentsUploaded;
      case 'info_remaining':
        return DriverOnboardingStatus.infoRemaining;
      case 'rejected':
        return DriverOnboardingStatus.rejected;
      case null:
      case '':
        return isNewUser
            ? DriverOnboardingStatus.infoRemaining
            : DriverOnboardingStatus.approved;
      default:
        return DriverOnboardingStatus.unknown;
    }
  }

  @override
  List<Object?> get props => <Object?>[onboardingStatus];
}
