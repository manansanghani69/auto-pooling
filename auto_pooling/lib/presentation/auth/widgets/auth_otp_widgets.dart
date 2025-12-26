import 'package:auto_pooling/presentation/auth/bloc/auth_event.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/theme/text_style/app_text_styles.dart';
import '../../../i18n/localization.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/styling/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../constants/auth_constants.dart';
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

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
      _otpLength,
      (_) => TextEditingController(),
    );
    _focusNodes = List<FocusNode>.generate(_otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
      return;
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AuthOtpDigitField(
          controller: _controllers[0],
          focusNode: _focusNodes[0],
          textInputAction: TextInputAction.next,
          onChanged: (value) => _handleDigitChanged(0, value),
        ),
        const SizedBox(width: AuthConstants.otpDigitSpacing),
        AuthOtpDigitField(
          controller: _controllers[1],
          focusNode: _focusNodes[1],
          textInputAction: TextInputAction.next,
          onChanged: (value) => _handleDigitChanged(1, value),
        ),
        const SizedBox(width: AuthConstants.otpDigitSpacing),
        AuthOtpDigitField(
          controller: _controllers[2],
          focusNode: _focusNodes[2],
          textInputAction: TextInputAction.next,
          onChanged: (value) => _handleDigitChanged(2, value),
        ),
        const SizedBox(width: AuthConstants.otpDigitSpacing),
        AuthOtpDigitField(
          controller: _controllers[3],
          focusNode: _focusNodes[3],
          textInputAction: TextInputAction.done,
          onChanged: (value) => _handleDigitChanged(3, value),
        ),
      ],
    );
  }
}

class AuthOtpDigitField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;

  const AuthOtpDigitField({
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AuthConstants.otpDigitSize,
      height: AuthConstants.otpDigitSize,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: textInputAction,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: AppTextStyles.h2SemiBold.copyWith(
          fontSize: 16,
          color: context.currentTheme.textNeutralPrimary,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthConstants.otpDigitRadius),
            borderSide: BorderSide(
              width: 2,
              color: context.currentTheme.textNeutralSecondary.withAlpha(51),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthConstants.otpDigitRadius),
            borderSide: BorderSide(
              color: context.currentTheme.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
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
                onPressed: () => context
                    .read<AuthBloc>()
                    .add(const AuthOtpTimerStartedEvent()),
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
    return PrimaryButton(
      onPressed: () {},
      buttonText: context.localization.authOtpVerifyButton,
      icon: Icons.check_circle,
      height: AuthConstants.primaryButtonHeight,
      borderRadius: AuthConstants.primaryButtonRadius,
      elevation: 0,
      textStyle: AppTextStyles.p2Regular.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    );
  }
}
