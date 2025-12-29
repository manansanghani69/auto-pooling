import 'package:auto_pooling/presentation/auth/bloc/auth_event.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../common/theme/text_style/app_text_styles.dart';
import '../../../i18n/localization.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/styling/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../constants/auth_constants.dart';
import '../bloc/auth_state.dart';
import 'auth_shared_widgets.dart';

class AuthOtpHeader extends StatelessWidget {
  const AuthOtpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: AuthBackButton(),
    );
  }
}

class AuthOtpHeadlineSection extends StatelessWidget {
  const AuthOtpHeadlineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthOtpTitleText(),
        SizedBox(height: AuthConstants.titleSpacing),
        AuthOtpSubtitleSection(),
      ],
    );
  }
}

class AuthOtpTitleText extends StatelessWidget {
  const AuthOtpTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.authOtpTitle,
      style: AppTextStyles.h2SemiBold.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class AuthOtpSubtitleSection extends StatelessWidget {
  const AuthOtpSubtitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthOtpSubtitleText(),
        SizedBox(height: AuthConstants.fieldLabelSpacing),
        AuthOtpPhoneRow(),
      ],
    );
  }
}

class AuthOtpSubtitleText extends StatelessWidget {
  const AuthOtpSubtitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.authOtpSubtitle,
      style: AppTextStyles.p2Regular.copyWith(
        height: 1.5,
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class AuthOtpPhoneRow extends StatelessWidget {
  const AuthOtpPhoneRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8.0,
      children: const [AuthOtpPhoneText(), AuthOtpEditButton()],
    );
  }
}

class AuthOtpPhoneText extends StatelessWidget {
  const AuthOtpPhoneText({super.key});

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = context.select<AuthBloc, String>(
      (bloc) => bloc.state.phoneNumber,
    );
    final String countryCode = context.localization.authPhoneCountryCode;
    final String displayNumber = phoneNumber.isEmpty
        ? countryCode
        : '$countryCode $phoneNumber';

    return Text(
      displayNumber,
      style: AppTextStyles.p2Regular.copyWith(
        fontWeight: FontWeight.w600,
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class AuthOtpEditButton extends StatelessWidget {
  const AuthOtpEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.router.pop(),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        foregroundColor: context.currentTheme.secondary,
      ),
      child: Text(
        context.localization.authOtpEditAction,
        style: AppTextStyles.p3Medium.copyWith(
          color: context.currentTheme.secondary,
        ),
      ),
    );
  }
}

class AuthOtpInputSection extends StatelessWidget {
  const AuthOtpInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AuthConstants.otpRowMaxWidth,
        ),
        child: const AuthOtpInputFields(),
      ),
    );
  }
}

class AuthOtpInputFields extends StatefulWidget {
  const AuthOtpInputFields({super.key});

  @override
  State<AuthOtpInputFields> createState() => _AuthOtpInputFieldsState();
}

class _AuthOtpInputFieldsState extends State<AuthOtpInputFields> {
  static const int _otpLength = 4;

  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  String _lastSubmittedOtp = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleOtpChanged(String value) {
    context.read<AuthBloc>().add(AuthOtpChangedEvent(otp: value));
    if (value.length != _otpLength) {
      _lastSubmittedOtp = '';
      return;
    }
    _tryAutoVerify(value);
  }

  void _tryAutoVerify(String value) {
    final AuthBloc bloc = context.read<AuthBloc>();
    final AuthState state = bloc.state;
    if (state.status == AuthStatus.verifyingOtp ||
        state.status == AuthStatus.otpVerified) {
      return;
    }
    if (value == _lastSubmittedOtp) {
      return;
    }
    _lastSubmittedOtp = value;
    bloc.add(const AuthVerifyOtpEvent());
  }

  void _handleStateChange(AuthState state) {
    if (state.otp.isEmpty && _controller.text.isNotEmpty) {
      _controller.clear();
      _focusNode.requestFocus();
      _lastSubmittedOtp = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = context.select<AuthBloc, bool>((bloc) {
      final AuthState state = bloc.state;
      return state.status == AuthStatus.failure &&
          state.lastAction == AuthAction.verifyOtp &&
          state.errorMessage.isNotEmpty;
    });
    final bool isVerifying = context.select<AuthBloc, bool>(
      (bloc) => bloc.state.status == AuthStatus.verifyingOtp,
    );

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.otp != current.otp || previous.status != current.status,
      listener: (context, state) => _handleStateChange(state),
      child: AuthOtpPinputField(
        length: _otpLength,
        controller: _controller,
        focusNode: _focusNode,
        hasError: hasError,
        isDisabled: isVerifying,
        onChanged: _handleOtpChanged,
      ),
    );
  }
}

class AuthOtpPinputField extends StatelessWidget {
  final int length;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool hasError;
  final bool isDisabled;

  const AuthOtpPinputField({
    required this.length,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.hasError,
    required this.isDisabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color neutralBorder = context.currentTheme.textNeutralSecondary
        .withAlpha(51);
    final Color activeColor = hasError
        ? context.currentTheme.error
        : context.currentTheme.primary;

    final PinTheme defaultPinTheme = _buildPinTheme(
      context,
      borderColor: neutralBorder,
      glowColor: null,
    );
    final PinTheme focusedPinTheme = _buildPinTheme(
      context,
      borderColor: activeColor,
      glowColor: activeColor,
    );
    final PinTheme errorPinTheme = _buildPinTheme(
      context,
      borderColor: context.currentTheme.error,
      glowColor: context.currentTheme.error,
    );

    return Pinput(
      length: length,
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      enabled: !isDisabled,
      mainAxisAlignment: MainAxisAlignment.center,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      errorPinTheme: errorPinTheme,
      submittedPinTheme: defaultPinTheme,
      followingPinTheme: defaultPinTheme,
      forceErrorState: hasError,
      separatorBuilder: _buildOtpSeparator,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }

  PinTheme _buildPinTheme(
    BuildContext context, {
    required Color borderColor,
    required Color? glowColor,
  }) {
    return PinTheme(
      width: AuthConstants.otpDigitSize,
      height: AuthConstants.otpDigitSize,
      textStyle: AppTextStyles.h2SemiBold.copyWith(
        fontSize: 24,
        color: context.currentTheme.textNeutralPrimary,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AuthConstants.otpDigitRadius),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: glowColor == null
            ? const []
            : [
                BoxShadow(
                  color: glowColor.withAlpha(60),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
      ),
    );
  }
}

Widget _buildOtpSeparator(int index) => const AuthOtpDigitSeparator();

class AuthOtpDigitSeparator extends StatelessWidget {
  const AuthOtpDigitSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: AuthConstants.otpDigitSpacing);
  }
}

class AuthOtpTimerSection extends StatelessWidget {
  const AuthOtpTimerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: AuthOtpTimerChip());
  }
}

class AuthOtpTimerChip extends StatelessWidget {
  const AuthOtpTimerChip({super.key});

  String _formatTimer(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;

    final String minutesText = minutes.toString().padLeft(2, '0');
    final String secondsText = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesText:$secondsText';
  }

  @override
  Widget build(BuildContext context) {
    final int secondsRemaining = context.select<AuthBloc, int>(
      (bloc) => bloc.state.otpSecondsRemaining,
    );
    final String timerText = _formatTimer(secondsRemaining);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.currentTheme.backgroundPrimary.withAlpha(153),
        borderRadius: BorderRadius.circular(AuthConstants.otpTimerRadius),
        border: Border.all(
          color: context.currentTheme.textNeutralSecondary.withAlpha(38),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AuthConstants.otpTimerPaddingHorizontal,
          vertical: AuthConstants.otpTimerPaddingVertical,
        ),
        child: secondsRemaining == 0
            ? AuthOtpResendAction(
                onPressed: () =>
                    context.read<AuthBloc>().add(const AuthRequestOtpEvent()),
              )
            : RichText(
                text: TextSpan(
                  style: AppTextStyles.p3Medium.copyWith(
                    color: context.currentTheme.textNeutralSecondary,
                  ),
                  children: [
                    TextSpan(text: context.localization.authOtpResendPrefix),
                    TextSpan(
                      text: timerText,
                      style: AppTextStyles.p3Medium.copyWith(
                        color: context.currentTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class AuthOtpResendAction extends StatelessWidget {
  final VoidCallback onPressed;

  const AuthOtpResendAction({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        foregroundColor: context.currentTheme.primary,
      ),
      child: Text(
        context.localization.authOtpResendAction,
        style: AppTextStyles.p3Medium.copyWith(
          color: context.currentTheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class AuthOtpVerifyButton extends StatelessWidget {
  const AuthOtpVerifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthState state = context.select<AuthBloc, AuthState>(
      (bloc) => bloc.state,
    );
    final bool isVerifying = state.status == AuthStatus.verifyingOtp;
    final bool isOtpComplete = state.otp.length == 4;

    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
        child: PrimaryButton(
          onPressed: isVerifying || !isOtpComplete
              ? null
              : () => context.read<AuthBloc>().add(const AuthVerifyOtpEvent()),
          buttonText: context.localization.authOtpVerifyButton,
          icon: Icons.check_circle,
          height: AuthConstants.primaryButtonHeight,
          borderRadius: AuthConstants.primaryButtonRadius,
          elevation: 0,
          textStyle: AppTextStyles.p2Regular.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
