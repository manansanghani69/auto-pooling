import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';
import 'constants/auth_constants.dart';
import 'widgets/auth_otp_widgets.dart';
import 'widgets/auth_shared_widgets.dart';
import '../../widgets/styling/app_colors.dart';

@RoutePage()
class AuthOtpScreen extends StatelessWidget {
  final AuthBloc authBloc;

  const AuthOtpScreen({required this.authBloc, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.status == AuthStatus.otpVerified) {
            context.router.replaceAll([const HomeRoute()]);
            return;
          }
          if (state.status == AuthStatus.failure &&
              (state.lastAction == AuthAction.verifyOtp ||
                  state.lastAction == AuthAction.requestOtp)) {
            _showAuthSnackBar(context, state.errorMessage);
          }
        },
        child: const Scaffold(
          body: AuthOtpBody(),
        ),
      ),
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

void _showAuthSnackBar(BuildContext context, String message) {
  if (message.isEmpty) {
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AuthSnackBarMessage(message: message),
      backgroundColor: context.currentTheme.error,
    ),
  );
}
