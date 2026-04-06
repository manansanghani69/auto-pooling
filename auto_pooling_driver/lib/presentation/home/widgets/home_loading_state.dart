import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/constants/app_constants.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class HomeLoadingState extends StatelessWidget {
  const HomeLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding,
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            HomeLoadingIndicator(),
            SizedBox(height: 16),
            HomeLoadingLabel(),
          ],
        ),
      ),
    );
  }
}

class HomeLoadingIndicator extends StatelessWidget {
  const HomeLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}

class HomeLoadingLabel extends StatelessWidget {
  const HomeLoadingLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.homeLoading,
      textAlign: TextAlign.center,
      style: AppTextStyles.p2Regular.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}
