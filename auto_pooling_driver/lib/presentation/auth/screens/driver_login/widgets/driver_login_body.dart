import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_bloc.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_state.dart';
import 'package:auto_pooling_driver/presentation/auth/screens/driver_login/widgets/driver_login_footer.dart';
import 'package:auto_pooling_driver/presentation/auth/screens/driver_login/widgets/driver_login_form_section.dart';
import 'package:auto_pooling_driver/presentation/auth/screens/driver_login/widgets/driver_login_hero_section.dart';
import 'package:auto_pooling_driver/routes.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverLoginBody extends StatelessWidget {
  const DriverLoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: <BlocListener<AuthBloc, AuthState>>[
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (AuthState previous, AuthState current) =>
              previous.requestOtpStatus != current.requestOtpStatus &&
              current.requestOtpStatus == AuthSubmissionStatus.success,
          listener: (BuildContext context, AuthState state) {
            context.pushRoute(
              DriverOtpRoute(authBloc: context.read<AuthBloc>()),
            );
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (AuthState previous, AuthState current) =>
              previous.helpDialogRequestCount != current.helpDialogRequestCount,
          listener: (BuildContext context, AuthState state) {
            showDialog<void>(
              context: context,
              builder: (BuildContext dialogContext) {
                return const DriverLoginHelpDialog();
              },
            );
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: context.currentTheme.backgroundPrimary,
        body: const SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                DriverLoginHeroSection(),
                DriverLoginFormSection(),
                DriverLoginFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
