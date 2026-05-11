import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_bloc.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_event.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_state.dart';
import 'package:auto_pooling_driver/presentation/auth/screens/otp/widgets/driver_otp_content.dart';
import 'package:auto_pooling_driver/presentation/auth/screens/otp/widgets/driver_otp_keypad.dart';
import 'package:auto_pooling_driver/routes.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverOtpBody extends StatelessWidget {
  const DriverOtpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (AuthState previous, AuthState current) =>
          previous.verifyOtpStatus != current.verifyOtpStatus &&
          current.verifyOtpStatus == AuthSubmissionStatus.success,
      listener: (BuildContext context, AuthState state) {
        context.router.replaceAll(<PageRouteInfo<dynamic>>[
          const DriverSplashRoute(),
        ]);
      },
      child: Focus(
        autofocus: true,
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is! KeyDownEvent) {
            return KeyEventResult.ignored;
          }

          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            context.read<AuthBloc>().add(const AuthOtpDigitRemovedEvent());
            return KeyEventResult.handled;
          }

          final String? character = event.character;
          if (character != null && RegExp(r'^\d$').hasMatch(character)) {
            context.read<AuthBloc>().add(
              AuthOtpDigitAppendedEvent(digit: character),
            );
            return KeyEventResult.handled;
          }

          return KeyEventResult.ignored;
        },
        child: Scaffold(
          backgroundColor: context.currentTheme.backgroundSurface,
          body: const SafeArea(bottom: false, child: DriverOtpContent()),
          bottomNavigationBar: const DriverOtpKeypad(),
        ),
      ),
    );
  }
}
