import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class OnboardingHeaderCopy extends StatelessWidget {
  const OnboardingHeaderCopy({
    required this.title,
    required this.description,
    this.leadingIcon,
    super.key,
  });

  final String title;
  final String description;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (leadingIcon != null) ...<Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: context.currentTheme.highlightSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              leadingIcon,
              color: context.currentTheme.accentPrimary,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          title,
          style: AppTextStyles.h1Bold.copyWith(
            color: context.currentTheme.textNeutralPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: AppTextStyles.p2Regular.copyWith(
            color: context.currentTheme.textNeutralSecondary,
          ),
        ),
      ],
    );
  }
}
