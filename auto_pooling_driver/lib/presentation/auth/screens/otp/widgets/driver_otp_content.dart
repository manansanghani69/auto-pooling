import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_bloc.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_event.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_state.dart';
import 'package:auto_pooling_driver/presentation/auth/constants/auth_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverOtpContent extends StatelessWidget {
  const DriverOtpContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        DriverOtpNavigationHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DriverOtpHeader(),
                SizedBox(height: 24),
                DriverOtpStatusBanner(),
                DriverOtpDigitRow(),
                SizedBox(height: 28),
                DriverOtpResendSection(),
                SizedBox(height: 18),
                DriverOtpVerifyButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DriverOtpNavigationHeader extends StatelessWidget {
  const DriverOtpNavigationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          onPressed: () {
            context.read<AuthBloc>().add(
              const AuthOtpEditPhoneRequestedEvent(),
            );
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
    );
  }
}

class DriverOtpHeader extends StatelessWidget {
  const DriverOtpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = context.select<AuthBloc, String>(
      (AuthBloc bloc) => bloc.state.activePhoneNumber,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.localization.authOtpTitle,
          style: AppTextStyles.h1Bold.copyWith(
            color: context.currentTheme.textNeutralPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          context.localization.authOtpSubtitle,
          style: AppTextStyles.p2Regular.copyWith(
            color: context.currentTheme.textNeutralSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                AuthFormatters.formatPhoneWithCountry(phoneNumber),
                style: AppTextStyles.p1Medium.copyWith(
                  color: context.currentTheme.textNeutralPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                context.read<AuthBloc>().add(
                  const AuthOtpEditPhoneRequestedEvent(),
                );
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: Text(context.localization.authEditAction),
            ),
          ],
        ),
      ],
    );
  }
}

class DriverOtpStatusBanner extends StatelessWidget {
  const DriverOtpStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthState state = context.select<AuthBloc, AuthState>(
      (AuthBloc bloc) => bloc.state,
    );

    final String? message =
        state.verifyOtpFailure?.message ?? state.requestOtpFailure?.message;

    if (message == null || message.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3F2),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFBC8C4)),
        ),
        child: Text(
          message,
          style: AppTextStyles.p2Regular.copyWith(
            color: const Color(0xFFB42318),
          ),
        ),
      ),
    );
  }
}

class DriverOtpDigitRow extends StatelessWidget {
  const DriverOtpDigitRow({super.key});

  @override
  Widget build(BuildContext context) {
    final String otpCode = context.select<AuthBloc, String>(
      (AuthBloc bloc) => bloc.state.otpCode,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List<Widget>.generate(AuthConstants.otpLength, (int index) {
        final bool isFilled = index < otpCode.length;
        final String digit = isFilled ? otpCode[index] : '';
        final bool isActive =
            otpCode.length == index ||
            (otpCode.length == AuthConstants.otpLength &&
                index == AuthConstants.otpLength - 1);

        return DriverOtpDigitBox(digit: digit, isActive: isActive);
      }),
    );
  }
}

class DriverOtpDigitBox extends StatelessWidget {
  const DriverOtpDigitBox({
    required this.digit,
    required this.isActive,
    super.key,
  });

  final String digit;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isActive
        ? context.currentTheme.accentPrimary
        : context.currentTheme.strokeSubtle;

    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: context.currentTheme.backgroundPrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: isActive ? 1.8 : 1),
      ),
      child: Center(
        child: Text(
          digit,
          style: AppTextStyles.h2Bold.copyWith(
            color: context.currentTheme.textNeutralPrimary,
          ),
        ),
      ),
    );
  }
}

class DriverOtpResendSection extends StatelessWidget {
  const DriverOtpResendSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthState state = context.select<AuthBloc, AuthState>(
      (AuthBloc bloc) => bloc.state,
    );

    if (state.isResendAvailable) {
      return Center(
        child: TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(const AuthResendOtpRequestedEvent());
          },
          child: Text(context.localization.authResendAction),
        ),
      );
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: context.currentTheme.backgroundPrimary,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          '${context.localization.authResendInAction} '
          '${AuthFormatters.formatSeconds(state.resendSecondsRemaining)}',
          style: AppTextStyles.p3Medium.copyWith(
            color: context.currentTheme.textNeutralSecondary,
          ),
        ),
      ),
    );
  }
}

class DriverOtpVerifyButton extends StatelessWidget {
  const DriverOtpVerifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthState state = context.select<AuthBloc, AuthState>(
      (AuthBloc bloc) => bloc.state,
    );

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: state.canVerifyOtp
            ? () {
                context.read<AuthBloc>().add(
                  const AuthVerifyOtpSubmittedEvent(),
                );
              }
            : null,
        child: state.isVerifyingOtp
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(context.localization.authVerifyAction),
                  const SizedBox(width: 8),
                  const Icon(Icons.check_circle_outline_rounded),
                ],
              ),
      ),
    );
  }
}
