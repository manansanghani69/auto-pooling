import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class OnboardingFooterAction extends StatelessWidget {
  const OnboardingFooterAction({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.secondary,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
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
              child: OnboardingFooterPrimaryButton(
                label: label,
                isLoading: isLoading,
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

class OnboardingFooterPrimaryButton extends StatelessWidget {
  const OnboardingFooterPrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        child: isLoading
            ? const OnboardingFooterLoadingIndicator()
            : Text(
                label,
                style: AppTextStyles.p1Medium.copyWith(
                  color: context.currentTheme.backgroundSurface,
                ),
              ),
      ),
    );
  }
}

class OnboardingFooterLoadingIndicator extends StatelessWidget {
  const OnboardingFooterLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(strokeWidth: 2.2),
    );
  }
}
