import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class OnboardingProgressSection extends StatelessWidget {
  const OnboardingProgressSection({
    required this.step,
    required this.totalSteps,
    super.key,
  });

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final double progress = step / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: context.currentTheme.strokeSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(
              context.currentTheme.accentPrimary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            context.localization.onboardingStepProgress(step, totalSteps),
            style: AppTextStyles.p3Medium.copyWith(
              color: context.currentTheme.textNeutralSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
