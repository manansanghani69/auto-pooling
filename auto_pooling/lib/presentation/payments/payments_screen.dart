import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'constants/payments_constants.dart';
import 'widgets/payments_placeholder_widgets.dart';

@RoutePage()
class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PaymentsBody(),
    );
  }
}

class PaymentsBody extends StatelessWidget {
  const PaymentsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: PaymentsConstants.horizontalPadding,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: PaymentsConstants.sectionSpacing),
            PaymentsTitleText(),
            SizedBox(height: PaymentsConstants.titleSpacing),
            PaymentsSubtitleText(),
            SizedBox(height: PaymentsConstants.sectionSpacing),
            PaymentsPrimaryActionButton(),
          ],
        ),
      ),
    );
  }
}
