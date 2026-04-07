import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class OnboardingGenderOption extends StatelessWidget {
  const OnboardingGenderOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? context.currentTheme.highlightSurface
                : context.currentTheme.backgroundSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? context.currentTheme.accentPrimary
                  : context.currentTheme.strokeSubtle,
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: isSelected
                    ? context.currentTheme.accentPrimary
                    : context.currentTheme.textNeutralSecondary,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.p2Regular.copyWith(
                  color: isSelected
                      ? context.currentTheme.accentPrimary
                      : context.currentTheme.textNeutralPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
