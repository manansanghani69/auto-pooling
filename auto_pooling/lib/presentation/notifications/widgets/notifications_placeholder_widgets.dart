import 'package:flutter/material.dart';

import '../../../common/theme/text_style/app_text_styles.dart';
import '../../../i18n/localization.dart';
import '../../../widgets/styling/app_colors.dart';

class NotificationsTitleText extends StatelessWidget {
  const NotificationsTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.notificationsTitle,
      style: AppTextStyles.h2SemiBold.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class NotificationsSubtitleText extends StatelessWidget {
  const NotificationsSubtitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.notificationsSubtitle,
      style: AppTextStyles.p2Regular.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class NotificationsPrimaryActionButton extends StatelessWidget {
  const NotificationsPrimaryActionButton({super.key});

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
