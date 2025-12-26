import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc.dart';
import 'constants/auth_constants.dart';
import 'widgets/auth_phone_widgets.dart';

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(),
      child: const Scaffold(
        body: AuthPhoneBody(),
      ),
    );
  }
}

class AuthPhoneBody extends StatelessWidget {
  const AuthPhoneBody({super.key});

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
            AuthPhoneHeader(),
            SizedBox(height: AuthConstants.sectionSpacing),
            AuthHeroCard(),
            SizedBox(height: AuthConstants.sectionSpacing),
            AuthPhoneHeadlineSection(),
            SizedBox(height: AuthConstants.sectionSpacing),
            AuthPhoneFormSection(),
            SizedBox(height: AuthConstants.bottomSpacing),
          ],
        ),
      ),
    );
  }
}
