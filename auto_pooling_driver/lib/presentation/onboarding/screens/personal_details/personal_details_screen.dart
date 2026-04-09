import 'package:auto_pooling_driver/core/services/injection_container.dart';
import 'package:auto_pooling_driver/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:auto_pooling_driver/presentation/onboarding/screens/personal_details/widgets/personal_details_body.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DriverOnboardingPersonalDetailsScreen extends StatelessWidget {
  const DriverOnboardingPersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingBloc>(
      create: (_) =>
          sl<OnboardingBloc>()..add(const OnboardingInitializedEvent()),
      child: const PersonalDetailsBody(),
    );
  }
}
