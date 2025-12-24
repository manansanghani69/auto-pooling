import 'package:flutter/material.dart';

import '../../../common/theme/text_style/app_text_styles.dart';
import '../../../i18n/localization.dart';
import '../../../widgets/styling/app_colors.dart';

class ProfileTitleText extends StatelessWidget {
  const ProfileTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.profileTitle,
      style: AppTextStyles.h2SemiBold.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class ProfileSubtitleText extends StatelessWidget {
  const ProfileSubtitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.profileSubtitle,
      style: AppTextStyles.p2Regular.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class ProfilePrimaryActionButton extends StatelessWidget {
  const ProfilePrimaryActionButton({super.key});

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
