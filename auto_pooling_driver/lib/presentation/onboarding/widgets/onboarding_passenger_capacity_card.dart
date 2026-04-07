import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class OnboardingPassengerCapacityCard extends StatelessWidget {
  const OnboardingPassengerCapacityCard({
    required this.capacity,
    required this.onDecrement,
    required this.onIncrement,
    super.key,
  });

  final int capacity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.currentTheme.backgroundSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.currentTheme.strokeSubtle),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: context.currentTheme.highlightSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.groups_rounded,
              color: context.currentTheme.accentPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.localization.onboardingPassengerCapacityLabel,
              style: AppTextStyles.p1Medium.copyWith(
                color: context.currentTheme.textNeutralPrimary,
              ),
            ),
          ),
          IconButton.outlined(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove_rounded),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$capacity',
              textAlign: TextAlign.center,
              style: AppTextStyles.h2Bold.copyWith(
                color: context.currentTheme.textNeutralPrimary,
              ),
            ),
          ),
          IconButton.filled(
            onPressed: onIncrement,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}
