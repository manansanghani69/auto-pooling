import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:equatable/equatable.dart';

class DriverOnboardingProfile extends Equatable {
  const DriverOnboardingProfile({
    required this.phoneNumber,
    required this.onboardingStatus,
    this.name = '',
    this.residentialAddress = '',
    this.vehicleType = '',
    this.vehicleRegistrationNumber = '',
    this.passengerCapacity = 3,
    this.gender,
  });

  final String phoneNumber;
  final DriverOnboardingStatus onboardingStatus;
  final String name;
  final String residentialAddress;
  final String vehicleType;
  final String vehicleRegistrationNumber;
  final int passengerCapacity;
  final String? gender;

  @override
  List<Object?> get props => <Object?>[
    phoneNumber,
    onboardingStatus,
    name,
    residentialAddress,
    vehicleType,
    vehicleRegistrationNumber,
    passengerCapacity,
    gender,
  ];
}
