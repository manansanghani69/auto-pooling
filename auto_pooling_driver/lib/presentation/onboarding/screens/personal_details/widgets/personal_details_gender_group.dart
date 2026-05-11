import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_gender_option.dart';
import 'package:flutter/material.dart';

class PersonalDetailsGenderGroup extends StatelessWidget {
  const PersonalDetailsGenderGroup({
    required this.selectedGender,
    required this.onGenderSelected,
    this.errorText,
    super.key,
  });

  final String? selectedGender;
  final ValueChanged<String> onGenderSelected;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.localization.onboardingGenderLabel,
          style: AppTextStyles.p3Medium.copyWith(
            color: context.currentTheme.textNeutralSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            OnboardingGenderOption(
              label: context.localization.onboardingGenderMaleLabel,
              icon: Icons.male_rounded,
              isSelected: selectedGender == 'male',
              onTap: () => onGenderSelected('male'),
            ),
            const SizedBox(width: 12),
            OnboardingGenderOption(
              label: context.localization.onboardingGenderFemaleLabel,
              icon: Icons.female_rounded,
              isSelected: selectedGender == 'female',
              onTap: () => onGenderSelected('female'),
            ),
            const SizedBox(width: 12),
            OnboardingGenderOption(
              label: context.localization.onboardingGenderOtherLabel,
              icon: Icons.transgender_rounded,
              isSelected: selectedGender == 'other',
              onTap: () => onGenderSelected('other'),
            ),
          ],
        ),
        if (errorText != null) ...<Widget>[
          const SizedBox(height: 6),
          PersonalDetailsGenderError(errorText: errorText!),
        ],
      ],
    );
  }
}

class PersonalDetailsGenderError extends StatelessWidget {
  const PersonalDetailsGenderError({required this.errorText, super.key});

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorText,
      style: AppTextStyles.p3Medium.copyWith(
        color: context.currentTheme.accentSecondary,
      ),
    );
  }
}
