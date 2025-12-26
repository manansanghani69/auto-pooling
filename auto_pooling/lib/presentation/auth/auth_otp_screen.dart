import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'constants/auth_constants.dart';
import 'widgets/auth_otp_widgets.dart';

@RoutePage()
class AuthOtpScreen extends StatelessWidget {
  const AuthOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AuthOtpBody(),
    );
  }
}

class AuthOtpBody extends StatelessWidget {
  const AuthOtpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AuthConstants.horizontalPadding,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AuthConstants.headerTopPadding),
            AuthOtpHeader(),
            SizedBox(height: AuthConstants.sectionSpacing),
            AuthOtpHeadlineSection(),
            SizedBox(height: AuthConstants.sectionSpacing),
            AuthOtpInputSection(),
            SizedBox(height: AuthConstants.sectionSpacing),
            AuthOtpTimerSection(),
            SizedBox(height: AuthConstants.sectionSpacing),
            AuthOtpVerifyButton(),
            SizedBox(height: AuthConstants.bottomSpacing),
          ],
        ),
      ),
    );
  }
}
