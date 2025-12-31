import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/injection_container.dart';
import '../../routes.dart';
import '../../widgets/app_snack_bar_message.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';
import 'constants/auth_constants.dart';
import 'widgets/auth_phone_widgets.dart';
import '../../widgets/styling/app_colors.dart';

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(authUseCase: sl()),
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          final bool isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
          if (!isCurrent) {
            return;
          }
          if (state.status == AuthStatus.otpRequested) {
            context.pushRoute(
              AuthOtpRoute(authBloc: context.read<AuthBloc>()),
            );
            return;
          }
          if (state.status == AuthStatus.failure &&
              state.lastAction == AuthAction.requestOtp) {
            _showAuthSnackBar(context, state.errorMessage);
          }
        },
        child: const Scaffold(
          body: AuthPhoneBody(),
        ),
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

void _showAuthSnackBar(BuildContext context, String message) {
  if (message.isEmpty) {
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AppSnackBarMessage(message: message),
      backgroundColor: context.currentTheme.error,
    ),
  );
}
