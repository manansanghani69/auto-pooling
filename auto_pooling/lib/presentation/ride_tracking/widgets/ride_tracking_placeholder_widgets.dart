import 'package:flutter/material.dart';

import '../../../common/theme/text_style/app_text_styles.dart';
import '../../../i18n/localization.dart';
import '../../../widgets/styling/app_colors.dart';

class RideTrackingTitleText extends StatelessWidget {
  const RideTrackingTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.rideTrackingTitle,
      style: AppTextStyles.h2SemiBold.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class RideTrackingSubtitleText extends StatelessWidget {
  const RideTrackingSubtitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.rideTrackingSubtitle,
      style: AppTextStyles.p2Regular.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class RideTrackingPrimaryActionButton extends StatelessWidget {
  const RideTrackingPrimaryActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: null,
        child: Text(
          context.localization.scaffoldOnlyCta,
          style: AppTextStyles.p2Regular,
        ),
      ),
    );
  }
}
