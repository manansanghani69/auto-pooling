import 'package:auto_pooling_driver/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';

class OnboardingFooterAction extends StatelessWidget {
  const OnboardingFooterAction({
    required this.label,
    required this.onPressed,
    this.secondary,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? secondary;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IgnorePointer(
            ignoring: onPressed == null,
            child: Opacity(
              opacity: onPressed == null ? 0.45 : 1,
              child: AppPrimaryButton(
                label: label,
                onPressed: onPressed ?? () {},
              ),
            ),
          ),
          if (secondary != null) ...<Widget>[
            const SizedBox(height: 12),
            secondary!,
          ],
        ],
      ),
    );
  }
}
