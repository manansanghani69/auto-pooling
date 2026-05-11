import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/constants/app_constants.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class OnboardingLoadingState extends StatelessWidget {
  const OnboardingLoadingState({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const OnboardingLoadingIndicator(),
            const SizedBox(height: 16),
            OnboardingLoadingMessage(message: message),
          ],
        ),
      ),
    );
  }
}

class OnboardingLoadingIndicator extends StatelessWidget {
  const OnboardingLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}

class OnboardingLoadingMessage extends StatelessWidget {
  const OnboardingLoadingMessage({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: AppTextStyles.p2Regular.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}
