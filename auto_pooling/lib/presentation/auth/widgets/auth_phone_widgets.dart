import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/theme/text_style/app_text_styles.dart';
import '../../../i18n/localization.dart';
import '../../../routes.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_text_field.dart';
import '../../../widgets/styling/app_colors.dart';
import '../constants/auth_constants.dart';
import 'auth_shared_widgets.dart';

class AuthPhoneHeader extends StatelessWidget {
  const AuthPhoneHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: AuthBackButton(),
    );
  }
}

class AuthHeroCard extends StatelessWidget {
  const AuthHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: AuthConstants.heroAspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AuthConstants.heroRadius),
        child: const Stack(
          children: [
            AuthHeroBackground(),
            AuthHeroTopAccent(),
            AuthHeroBottomAccent(),
            Center(child: AuthHeroIcon()),
          ],
        ),
      ),
    );
  }
}

class AuthHeroBackground extends StatelessWidget {
  const AuthHeroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.currentTheme.primary.withAlpha(20),
            context.currentTheme.primary.withAlpha(46),
          ],
        ),
      ),
    );
  }
}

class AuthHeroTopAccent extends StatelessWidget {
  const AuthHeroTopAccent({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -AuthConstants.heroAccentSize * 0.3,
      right: -AuthConstants.heroAccentSize * 0.3,
      child: AuthHeroAccentCircle(
        color: context.currentTheme.primary.withAlpha(31),
      ),
    );
  }
}

class AuthHeroBottomAccent extends StatelessWidget {
  const AuthHeroBottomAccent({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -AuthConstants.heroAccentSize * 0.2,
      left: AuthConstants.heroAccentSize * 0.2,
      child: AuthHeroAccentCircle(
        color: context.currentTheme.secondary.withAlpha(46),
      ),
    );
  }
}

class AuthHeroAccentCircle extends StatelessWidget {
  final Color color;

  const AuthHeroAccentCircle({required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AuthConstants.heroAccentSize,
      width: AuthConstants.heroAccentSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class AuthHeroIcon extends StatelessWidget {
  const AuthHeroIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.directions_car_filled,
      size: AuthConstants.heroIconSize,
      color: context.currentTheme.primary,
    );
  }
}

class AuthPhoneHeadlineSection extends StatelessWidget {
  const AuthPhoneHeadlineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthPhoneHeadlineText(),
        SizedBox(height: AuthConstants.titleSpacing),
        AuthPhoneSubtitleText(),
      ],
    );
  }
}

class AuthPhoneHeadlineText extends StatelessWidget {
  const AuthPhoneHeadlineText({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = AppTextStyles.h2SemiBold.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.1,
      color: context.currentTheme.textNeutralPrimary,
    );

    return Text.rich(
      TextSpan(
        text: context.localization.authPhoneTitlePrefix,
        children: [
          TextSpan(
            text: context.localization.authPhoneTitleHighlight,
            style: baseStyle.copyWith(
              color: context.currentTheme.primary,
            ),
          ),
        ],
      ),
      style: baseStyle,
    );
  }
}

class AuthPhoneSubtitleText extends StatelessWidget {
  const AuthPhoneSubtitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.authPhoneSubtitle,
      style: AppTextStyles.p2Regular.copyWith(
        fontSize: 16,
        height: 1.5,
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class AuthPhoneFormSection extends StatelessWidget {
  const AuthPhoneFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthPhoneInputRow(),
          SizedBox(height: AuthConstants.formSpacing),
          AuthGetOtpButton(),
        ],
      ),
    );
  }
}

class AuthPhoneInputRow extends StatelessWidget {
  const AuthPhoneInputRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthCountryCodeField(),
        SizedBox(width: AuthConstants.fieldSpacing),
        Expanded(child: AuthPhoneNumberField()),
      ],
    );
  }
}

class AuthCountryCodeField extends StatelessWidget {
  const AuthCountryCodeField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AuthConstants.countryCodeWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthFieldLabel(text: context.localization.authPhoneCodeLabel),
          const SizedBox(height: AuthConstants.fieldLabelSpacing),
          const AuthCountryCodeSelector(),
        ],
      ),
    );
  }
}

class AuthCountryCodeSelector extends StatelessWidget {
  const AuthCountryCodeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AuthConstants.inputFieldRadius),
          border: Border.all(
            color: context.currentTheme.textNeutralSecondary.withAlpha(51),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AuthCountryCodeValue(
                code: context.localization.authPhoneCountryCode,
              ),
              const AuthCountryCodeChevron(),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCountryCodeValue extends StatelessWidget {
  final String code;

  const AuthCountryCodeValue({required this.code, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      code,
      style: AppTextStyles.p2Regular.copyWith(
        fontWeight: FontWeight.w600,
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class AuthCountryCodeChevron extends StatelessWidget {
  const AuthCountryCodeChevron({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.expand_more,
      color: context.currentTheme.textNeutralSecondary,
      size: AuthConstants.countryCodeIconSize,
    );
  }
}

class AuthPhoneNumberField extends StatelessWidget {
  const AuthPhoneNumberField({super.key});

  String? _validatePhoneNumber(BuildContext context, String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return context.localization.authPhoneNumberEmptyError;
    }
    if (trimmed.length != AuthConstants.phoneNumberLength) {
      return context.localization.authPhoneNumberInvalidError;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthFieldLabel(text: context.localization.authPhoneNumberLabel),
        const SizedBox(height: AuthConstants.fieldLabelSpacing),
        PrimaryTextField(
          height: 64,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          validator: (value) => _validatePhoneNumber(context, value),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(AuthConstants.phoneNumberLength),
          ],
          hintText: context.localization.authPhoneNumberHint,
          textStyle: AppTextStyles.p2Regular.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          hintStyle: AppTextStyles.p2Regular.copyWith(
            color: context.currentTheme.textNeutralSecondary,
          ),
          borderRadius: AuthConstants.inputFieldRadius,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ],
    );
  }
}

class AuthFieldLabel extends StatelessWidget {
  final String text;

  const AuthFieldLabel({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.p3Medium.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class AuthGetOtpButton extends StatelessWidget {
  const AuthGetOtpButton({super.key});

  void _handleTap(BuildContext context) {
    final FormState? formState = Form.of(context);
    if (formState == null || !formState.validate()) {
      return;
    }
    context.pushRoute(const AuthOtpRoute());
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: () => _handleTap(context),
      buttonText: context.localization.authGetOtpButton,
      icon: Icons.arrow_forward,
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
