import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_placeholder_avatar.dart';
import 'package:flutter/material.dart';

class PersonalDetailsProfilePhoto extends StatelessWidget {
  const PersonalDetailsProfilePhoto({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OnboardingPlaceholderAvatar(
        label: context.localization.onboardingUploadProfilePhotoAction,
        onTap: onTap,
      ),
    );
  }
}
