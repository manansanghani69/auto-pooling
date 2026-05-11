import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/core/extensions/failure_x.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_bloc.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_event.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_state.dart';
import 'package:auto_pooling_driver/presentation/auth/constants/auth_constants.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverLoginFormSection extends StatelessWidget {
  const DriverLoginFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -28),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
        decoration: BoxDecoration(
          color: context.currentTheme.backgroundSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: context.currentTheme.textNeutralPrimary.withValues(
                alpha: 0.06,
              ),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DriverLoginSheetHandle(),
            SizedBox(height: 20),
            DriverLoginHeadline(),
            SizedBox(height: 24),
            DriverLoginStatusCard(),
            DriverLoginPhoneFields(),
            SizedBox(height: 24),
            DriverLoginErrorMessage(),
            DriverLoginGetOtpButton(),
          ],
        ),
      ),
    );
  }
}

class DriverLoginSheetHandle extends StatelessWidget {
  const DriverLoginSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 48,
        height: 5,
        decoration: BoxDecoration(
          color: context.currentTheme.strokeSubtle,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class DriverLoginHeadline extends StatelessWidget {
  const DriverLoginHeadline({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.localization.authLoginTitle,
          style: AppTextStyles.h1Bold.copyWith(
            color: context.currentTheme.textNeutralPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          context.localization.authLoginSubtitle,
          style: AppTextStyles.p2Regular.copyWith(
            color: context.currentTheme.textNeutralSecondary,
          ),
        ),
      ],
    );
  }
}

class DriverLoginStatusCard extends StatelessWidget {
  const DriverLoginStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final DriverOnboardingStatus? onboardingStatus = context
        .select<AuthBloc, DriverOnboardingStatus?>(
          (AuthBloc bloc) => bloc.state.onboardingStatus,
        );

    if (onboardingStatus == null ||
        onboardingStatus == DriverOnboardingStatus.approved) {
      return const SizedBox.shrink();
    }

    final _DriverLoginStatusContent content = _DriverLoginStatusContent.from(
      onboardingStatus,
      context,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: content.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: content.borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DriverLoginStatusIcon(iconData: content.iconData),
            const SizedBox(width: 12),
            Expanded(
              child: DriverLoginStatusText(
                title: content.title,
                description: content.description,
                titleColor: content.titleColor,
                descriptionColor: content.descriptionColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DriverLoginStatusIcon extends StatelessWidget {
  const DriverLoginStatusIcon({required this.iconData, super.key});

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: context.currentTheme.backgroundSurface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        size: 18,
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class DriverLoginStatusText extends StatelessWidget {
  const DriverLoginStatusText({
    required this.title,
    required this.description,
    required this.titleColor,
    required this.descriptionColor,
    super.key,
  });

  final String title;
  final String description;
  final Color titleColor;
  final Color descriptionColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: AppTextStyles.p1Medium.copyWith(color: titleColor)),
        const SizedBox(height: 6),
        Text(
          description,
          style: AppTextStyles.p2Regular.copyWith(color: descriptionColor),
        ),
      ],
    );
  }
}

class DriverLoginPhoneFields extends StatelessWidget {
  const DriverLoginPhoneFields({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DriverCountryCodeField(),
        SizedBox(width: 12),
        Expanded(child: DriverPhoneNumberField()),
      ],
    );
  }
}

class DriverCountryCodeField extends StatelessWidget {
  const DriverCountryCodeField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DriverFieldLabel(label: context.localization.authCountryLabel),
          const SizedBox(height: 8),
          Container(
            height: 58,
            decoration: BoxDecoration(
              color: context.currentTheme.backgroundPrimary,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: context.currentTheme.strokeSubtle),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Row(
              children: <Widget>[
                Icon(Icons.flag_outlined, size: 18),
                SizedBox(width: 8),
                Text(AuthConstants.countryCode),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DriverPhoneNumberField extends StatefulWidget {
  const DriverPhoneNumberField({super.key});

  @override
  State<DriverPhoneNumberField> createState() => _DriverPhoneNumberFieldState();
}

class _DriverPhoneNumberFieldState extends State<DriverPhoneNumberField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<AuthBloc>().state.phoneNumber,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DriverFieldLabel(label: context.localization.authMobileNumberLabel),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(AuthConstants.phoneNumberLength),
          ],
          onChanged: (String value) {
            context.read<AuthBloc>().add(
              AuthPhoneNumberChangedEvent(phoneNumber: value),
            );
          },
          decoration: InputDecoration(
            hintText: context.localization.authMobileNumberHint,
            prefixIcon: const Icon(Icons.smartphone_outlined),
            filled: true,
            fillColor: context.currentTheme.backgroundSurface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: context.currentTheme.strokeSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: context.currentTheme.accentPrimary,
                width: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DriverFieldLabel extends StatelessWidget {
  const DriverFieldLabel({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.p3Medium.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class DriverLoginErrorMessage extends StatelessWidget {
  const DriverLoginErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthState state = context.select<AuthBloc, AuthState>(
      (AuthBloc bloc) => bloc.state,
    );

    if (state.requestOtpStatus != AuthSubmissionStatus.failure ||
        state.requestOtpFailure == null) {
      return const SizedBox(height: 0);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        state.requestOtpFailure!.resolveMessage(context.localization),
        style: AppTextStyles.p2Regular.copyWith(
          color: context.currentTheme.accentSecondary,
        ),
      ),
    );
  }
}

class DriverLoginGetOtpButton extends StatelessWidget {
  const DriverLoginGetOtpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthState state = context.select<AuthBloc, AuthState>(
      (AuthBloc bloc) => bloc.state,
    );

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: state.canSubmitPhoneNumber
            ? () {
                context.read<AuthBloc>().add(
                  const AuthRequestOtpSubmittedEvent(),
                );
              }
            : null,
        child: state.isRequestingOtp
            ? const DriverLoginLoadingIndicator()
            : const DriverLoginGetOtpContent(),
      ),
    );
  }
}

class DriverLoginLoadingIndicator extends StatelessWidget {
  const DriverLoginLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(strokeWidth: 2.2),
    );
  }
}

class DriverLoginGetOtpContent extends StatelessWidget {
  const DriverLoginGetOtpContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(context.localization.authGetOtpAction),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward_rounded),
      ],
    );
  }
}

class _DriverLoginStatusContent {
  const _DriverLoginStatusContent({
    required this.title,
    required this.description,
    required this.iconData,
    required this.backgroundColor,
    required this.borderColor,
    required this.titleColor,
    required this.descriptionColor,
  });

  final String title;
  final String description;
  final IconData iconData;
  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;
  final Color descriptionColor;

  factory _DriverLoginStatusContent.from(
    DriverOnboardingStatus status,
    BuildContext context,
  ) {
    switch (status) {
      case DriverOnboardingStatus.documentsUploaded:
        return _DriverLoginStatusContent(
          title: '',
          description: '',
          iconData: Icons.hourglass_top_rounded,
          backgroundColor: context.currentTheme.highlightSurface,
          borderColor: context.currentTheme.accentSecondary,
          titleColor: context.currentTheme.textNeutralPrimary,
          descriptionColor: context.currentTheme.textNeutralSecondary,
        )._localized(
          context.localization.authStatusPendingTitle,
          context.localization.authStatusPendingDescription,
        );
      case DriverOnboardingStatus.infoRemaining:
        return _DriverLoginStatusContent(
          title: context.localization.authStatusInfoRemainingTitle,
          description: context.localization.authStatusInfoRemainingDescription,
          iconData: Icons.description_outlined,
          backgroundColor: context.currentTheme.highlightSurface,
          borderColor: context.currentTheme.accentPrimary.withValues(
            alpha: 0.2,
          ),
          titleColor: context.currentTheme.textNeutralPrimary,
          descriptionColor: context.currentTheme.textNeutralSecondary,
        );
      case DriverOnboardingStatus.rejected:
        return _DriverLoginStatusContent(
          title: '',
          description: '',
          iconData: Icons.cancel_outlined,
          backgroundColor: context.currentTheme.highlightSurface,
          borderColor: context.currentTheme.accentSecondary,
          titleColor: context.currentTheme.textNeutralPrimary,
          descriptionColor: context.currentTheme.textNeutralSecondary,
        )._localized(
          context.localization.authStatusRejectedTitle,
          context.localization.authStatusRejectedDescription,
        );
      case DriverOnboardingStatus.unknown:
        return _DriverLoginStatusContent(
          title: context.localization.authStatusUnknownTitle,
          description: context.localization.authStatusUnknownDescription,
          iconData: Icons.info_outline_rounded,
          backgroundColor: context.currentTheme.backgroundPrimary,
          borderColor: context.currentTheme.strokeSubtle,
          titleColor: context.currentTheme.textNeutralPrimary,
          descriptionColor: context.currentTheme.textNeutralSecondary,
        );
      case DriverOnboardingStatus.approved:
        return _DriverLoginStatusContent(
          title: '',
          description: '',
          iconData: Icons.check_circle_outline_rounded,
          backgroundColor: context.currentTheme.highlightSurface,
          borderColor: context.currentTheme.strokeSubtle,
          titleColor: context.currentTheme.textNeutralPrimary,
          descriptionColor: context.currentTheme.textNeutralSecondary,
        );
    }
  }

  _DriverLoginStatusContent _localized(
    String titleText,
    String descriptionText,
  ) {
    return _DriverLoginStatusContent(
      title: titleText,
      description: descriptionText,
      iconData: iconData,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      titleColor: titleColor,
      descriptionColor: descriptionColor,
    );
  }
}
