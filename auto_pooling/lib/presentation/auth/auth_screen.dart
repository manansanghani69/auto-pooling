import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'constants/auth_constants.dart';
import 'widgets/auth_placeholder_widgets.dart';

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AuthBody(),
    );
  }
}

class AuthBody extends StatelessWidget {
  const AuthBody({super.key});

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
            SizedBox(height: AuthConstants.sectionSpacing),
            AuthTitleText(),
            SizedBox(height: AuthConstants.titleSpacing),
            AuthSubtitleText(),
            SizedBox(height: AuthConstants.sectionSpacing),
            AuthPrimaryActionButton(),
          ],
        ),
      ),
    );
  }
}
