import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_bloc.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverOtpKeypad extends StatelessWidget {
  const DriverOtpKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.currentTheme.backgroundPrimary,
        border: Border(
          top: BorderSide(color: context.currentTheme.strokeSubtle),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              DriverOtpKeypadRow(
                children: <Widget>[
                  DriverOtpDigitKeypadButton(digit: '1'),
                  DriverOtpDigitKeypadButton(digit: '2'),
                  DriverOtpDigitKeypadButton(digit: '3'),
                ],
              ),
              SizedBox(height: 12),
              DriverOtpKeypadRow(
                children: <Widget>[
                  DriverOtpDigitKeypadButton(digit: '4'),
                  DriverOtpDigitKeypadButton(digit: '5'),
                  DriverOtpDigitKeypadButton(digit: '6'),
                ],
              ),
              SizedBox(height: 12),
              DriverOtpKeypadRow(
                children: <Widget>[
                  DriverOtpDigitKeypadButton(digit: '7'),
                  DriverOtpDigitKeypadButton(digit: '8'),
                  DriverOtpDigitKeypadButton(digit: '9'),
                ],
              ),
              SizedBox(height: 12),
              DriverOtpKeypadRow(
                children: <Widget>[
                  DriverOtpKeypadSpacer(),
                  DriverOtpDigitKeypadButton(digit: '0'),
                  DriverOtpDeleteKeypadButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DriverOtpKeypadRow extends StatelessWidget {
  const DriverOtpKeypadRow({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(children: children);
  }
}

class DriverOtpDigitKeypadButton extends StatelessWidget {
  const DriverOtpDigitKeypadButton({required this.digit, super.key});

  final String digit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: DriverOtpKeypadButton(
          onPressed: () {
            context.read<AuthBloc>().add(
              AuthOtpDigitAppendedEvent(digit: digit),
            );
          },
          child: Text(
            digit,
            style: AppTextStyles.h2Bold.copyWith(
              color: context.currentTheme.textNeutralPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class DriverOtpDeleteKeypadButton extends StatelessWidget {
  const DriverOtpDeleteKeypadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: DriverOtpKeypadButton(
          onPressed: () {
            context.read<AuthBloc>().add(const AuthOtpDigitRemovedEvent());
          },
          child: const Icon(Icons.backspace_outlined),
        ),
      ),
    );
  }
}

class DriverOtpKeypadSpacer extends StatelessWidget {
  const DriverOtpKeypadSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(child: SizedBox.shrink());
  }
}

class DriverOtpKeypadButton extends StatelessWidget {
  const DriverOtpKeypadButton({
    required this.onPressed,
    required this.child,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          foregroundColor: context.currentTheme.textNeutralPrimary,
        ),
        child: child,
      ),
    );
  }
}
