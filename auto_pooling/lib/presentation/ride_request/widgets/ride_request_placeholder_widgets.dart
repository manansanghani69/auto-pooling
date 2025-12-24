import 'package:flutter/material.dart';

import '../../../common/theme/text_style/app_text_styles.dart';
import '../../../i18n/localization.dart';
import '../../../widgets/styling/app_colors.dart';

class RideRequestTitleText extends StatelessWidget {
  const RideRequestTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.rideRequestTitle,
      style: AppTextStyles.h2SemiBold.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class RideRequestSubtitleText extends StatelessWidget {
  const RideRequestSubtitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.rideRequestSubtitle,
      style: AppTextStyles.p2Regular.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class RideRequestPrimaryActionButton extends StatelessWidget {
  const RideRequestPrimaryActionButton({super.key});

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
