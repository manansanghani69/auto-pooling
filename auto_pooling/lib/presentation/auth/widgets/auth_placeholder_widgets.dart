import 'package:flutter/material.dart';

import '../../../common/theme/text_style/app_text_styles.dart';
import '../../../i18n/localization.dart';
import '../../../widgets/styling/app_colors.dart';

class AuthTitleText extends StatelessWidget {
  const AuthTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.authTitle,
      style: AppTextStyles.h2SemiBold.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class AuthSubtitleText extends StatelessWidget {
  const AuthSubtitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.authSubtitle,
      style: AppTextStyles.p2Regular.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class AuthPrimaryActionButton extends StatelessWidget {
  const AuthPrimaryActionButton({super.key});

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
