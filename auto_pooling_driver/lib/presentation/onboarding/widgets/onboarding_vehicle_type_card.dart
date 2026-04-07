import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class OnboardingVehicleTypeCard extends StatelessWidget {
  const OnboardingVehicleTypeCard({
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? context.currentTheme.highlightSurface
              : context.currentTheme.backgroundSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? context.currentTheme.accentPrimary
                : context.currentTheme.strokeSubtle,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? context.currentTheme.accentPrimary
                  : context.currentTheme.textNeutralSecondary,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: AppTextStyles.p2Regular.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? context.currentTheme.accentPrimary
                    : context.currentTheme.textNeutralPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
