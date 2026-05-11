import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/constants/app_constants.dart';
import 'package:auto_pooling_driver/core/errors/failures.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/core/extensions/failure_x.dart';
import 'package:auto_pooling_driver/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';

class OnboardingErrorState extends StatelessWidget {
  const OnboardingErrorState({
    required this.failure,
    required this.onRetry,
    super.key,
  });

  final Failure? failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final String message =
        failure?.resolveMessage(context.localization) ??
        context.localization.commonUnexpectedFailure;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const OnboardingErrorTitle(),
            const SizedBox(height: 12),
            OnboardingErrorDescription(message: message),
            const SizedBox(height: 20),
            OnboardingErrorRetryButton(onRetry: onRetry),
          ],
        ),
      ),
    );
  }
}

class OnboardingErrorTitle extends StatelessWidget {
  const OnboardingErrorTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.homeErrorTitle,
      textAlign: TextAlign.center,
      style: AppTextStyles.h2Bold.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class OnboardingErrorDescription extends StatelessWidget {
  const OnboardingErrorDescription({required this.message, super.key});

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

class OnboardingErrorRetryButton extends StatelessWidget {
  const OnboardingErrorRetryButton({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: context.localization.homeRetryAction,
      onPressed: onRetry,
    );
  }
}
