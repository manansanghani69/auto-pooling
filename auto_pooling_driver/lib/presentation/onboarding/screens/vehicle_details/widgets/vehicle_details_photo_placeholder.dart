import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_upload_placeholder.dart';
import 'package:flutter/material.dart';

class VehicleDetailsPhotoPlaceholder extends StatelessWidget {
  const VehicleDetailsPhotoPlaceholder({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OnboardingUploadPlaceholder(
      title: context.localization.onboardingVehiclePhotoTitle,
      description: context.localization.onboardingVehiclePhotoDescription,
      actionLabel: context.localization.onboardingUploadVehiclePhotoAction,
      onTap: onTap,
    );
  }
}
