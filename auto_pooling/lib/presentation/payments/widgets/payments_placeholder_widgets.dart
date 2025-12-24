import 'package:flutter/material.dart';

import '../../../common/theme/text_style/app_text_styles.dart';
import '../../../i18n/localization.dart';
import '../../../widgets/styling/app_colors.dart';

class PaymentsTitleText extends StatelessWidget {
  const PaymentsTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.paymentsTitle,
      style: AppTextStyles.h2SemiBold.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class PaymentsSubtitleText extends StatelessWidget {
  const PaymentsSubtitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.paymentsSubtitle,
      style: AppTextStyles.p2Regular.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class PaymentsPrimaryActionButton extends StatelessWidget {
  const PaymentsPrimaryActionButton({super.key});

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
