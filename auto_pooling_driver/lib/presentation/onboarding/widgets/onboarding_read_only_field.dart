import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class OnboardingReadOnlyField extends StatelessWidget {
  const OnboardingReadOnlyField({
    required this.label,
    required this.value,
    required this.trailing,
    super.key,
  });

  final String label;
  final String value;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: context.currentTheme.highlightSurface.withValues(
              alpha: 0.45,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.currentTheme.strokeSubtle),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: context.currentTheme.textNeutralSecondary,
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ],
    );
  }
}
