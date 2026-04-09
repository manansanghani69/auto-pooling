import 'package:auto_pooling_driver/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:auto_pooling_driver/presentation/onboarding/screens/vehicle_details/widgets/vehicle_details_body.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DriverOnboardingVehicleDetailsScreen extends StatelessWidget {
  const DriverOnboardingVehicleDetailsScreen({
    required this.onboardingBloc,
    super.key,
  });

  final OnboardingBloc onboardingBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingBloc>.value(
      value: onboardingBloc,
      child: const VehicleDetailsBody(),
    );
  }
}
