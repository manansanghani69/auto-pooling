import 'package:flutter/material.dart';

import '../common/theme/text_style/app_text_styles.dart';
import 'styling/app_colors.dart';

class AppSnackBarMessage extends StatelessWidget {
  final String message;

  const AppSnackBarMessage({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: AppTextStyles.p2Regular.copyWith(
        color: context.currentTheme.backgroundPrimary,
      ),
    );
  }
}
