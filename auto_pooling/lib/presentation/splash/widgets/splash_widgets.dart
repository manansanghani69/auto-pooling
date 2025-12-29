import 'package:flutter/material.dart';

import '../../../common/theme/text_style/app_text_styles.dart';
import '../../../i18n/localization.dart';
import '../../../widgets/styling/app_colors.dart';
import '../constants/splash_constants.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: context.currentTheme.backgroundPrimary,
        child: const Stack(
          children: [
            SplashTopGlow(),
            SplashBottomGlow(),
          ],
        ),
      ),
    );
  }
}

class SplashTopGlow extends StatelessWidget {
  const SplashTopGlow({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double size = height * 0.5;
    final double offset = -size * 0.2;

    return Positioned(
      top: offset,
      left: offset,
      child: SplashGlowCircle(
        size: size,
        color: context.currentTheme.primary.withAlpha(20),
      ),
    );
  }
}

class SplashBottomGlow extends StatelessWidget {
  const SplashBottomGlow({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double size = height * 0.5;
    final double offset = -size * 0.2;

    return Positioned(
      bottom: offset,
      right: offset,
      child: SplashGlowCircle(
        size: size,
        color: context.currentTheme.secondary.withAlpha(30),
      ),
    );
  }
}

class SplashGlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const SplashGlowCircle({
    required this.size,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: SplashConstants.glowBlurRadius,
            spreadRadius: SplashConstants.glowSpreadRadius,
          ),
        ],
      ),
    );
  }
}

class SplashContentContainer extends StatelessWidget {
  const SplashContentContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SplashConstants.horizontalPadding,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: SplashConstants.maxContentWidth,
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SplashLogoSection(),
            SizedBox(height: SplashConstants.logoTextSpacing),
            SplashTextSection(),
            SizedBox(height: SplashConstants.loadingSpacing),
            SplashLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}

class SplashLogoSection extends StatelessWidget {
  const SplashLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SplashConstants.logoSize + (SplashConstants.glowRingInset * 2),
      height: SplashConstants.logoSize + (SplashConstants.glowRingInset * 2),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          SplashLogoGlowRing(),
          SplashLogoIconBox(),
        ],
      ),
    );
  }
}

class SplashLogoGlowRing extends StatelessWidget {
  const SplashLogoGlowRing({super.key});

  @override
  Widget build(BuildContext context) {
    final double ringSize =
        SplashConstants.logoSize + (SplashConstants.glowRingInset * 2);
    final double radius =
        SplashConstants.logoCornerRadius + SplashConstants.glowRingInset;

    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.currentTheme.primary.withAlpha(89),
              context.currentTheme.secondary.withAlpha(89),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: context.currentTheme.primary.withAlpha(51),
              blurRadius: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}

class SplashLogoIconBox extends StatelessWidget {
  const SplashLogoIconBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SplashConstants.logoSize,
      height: SplashConstants.logoSize,
      child: Stack(
        children: const [
          Positioned.fill(child: SplashLogoSurface()),
          Center(child: SplashLogoIcon()),
          SplashConnectionDot(),
        ],
      ),
    );
  }
}

class SplashLogoSurface extends StatelessWidget {
  const SplashLogoSurface({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.currentTheme.primary,
        borderRadius: BorderRadius.circular(SplashConstants.logoCornerRadius),
        boxShadow: [
          BoxShadow(
            color: context.currentTheme.primary.withAlpha(51),
            blurRadius: 24.0,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(
          color: Colors.white.withAlpha(26),
        ),
      ),
    );
  }
}

class SplashLogoIcon extends StatelessWidget {
  const SplashLogoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.commute,
      size: SplashConstants.iconSize,
      color: Colors.white,
    );
  }
}

class SplashConnectionDot extends StatelessWidget {
  const SplashConnectionDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: SplashConstants.dotOffset,
      right: SplashConstants.dotOffset,
      child: Container(
        width: SplashConstants.dotSize,
        height: SplashConstants.dotSize,
        decoration: BoxDecoration(
          color: context.currentTheme.secondary,
          shape: BoxShape.circle,
          border: Border.all(
            color: context.currentTheme.primary,
            width: SplashConstants.dotBorderWidth,
          ),
        ),
      ),
    );
  }
}

class SplashTextSection extends StatelessWidget {
  const SplashTextSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SplashTitleText(),
        SizedBox(height: SplashConstants.textSpacing),
        SplashTaglineText(),
      ],
    );
  }
}

class SplashTitleText extends StatelessWidget {
  const SplashTitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.splashTitle,
      textAlign: TextAlign.center,
      style: AppTextStyles.h2SemiBold.copyWith(
        fontSize: SplashConstants.titleFontSize,
        fontWeight: FontWeight.w700,
        color: context.currentTheme.primary,
        height: 1.1,
      ),
    );
  }
}

class SplashTaglineText extends StatelessWidget {
  const SplashTaglineText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      spacing: SplashConstants.taglineWordSpacing,
      children: [
        SplashTaglinePrefixText(),
        SplashTaglineEmphasisText(),
      ],
    );
  }
}

class SplashTaglinePrefixText extends StatelessWidget {
  const SplashTaglinePrefixText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.splashTaglinePrefix,
      textAlign: TextAlign.center,
      style: AppTextStyles.p2Regular.copyWith(
        fontSize: SplashConstants.taglineFontSize,
        color: context.currentTheme.textNeutralSecondary,
        height: 1.4,
      ),
    );
  }
}

class SplashTaglineEmphasisText extends StatelessWidget {
  const SplashTaglineEmphasisText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.splashTaglineEmphasis,
      textAlign: TextAlign.center,
      style: AppTextStyles.p2Regular.copyWith(
        fontSize: SplashConstants.taglineFontSize,
        color: context.currentTheme.secondary,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
    );
  }
}

class SplashLoadingIndicator extends StatelessWidget {
  const SplashLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SplashConstants.loadingIndicatorSize,
      height: SplashConstants.loadingIndicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: SplashConstants.loadingIndicatorStroke,
        color: context.currentTheme.primary,
      ),
    );
  }
}

class SplashFooter extends StatelessWidget {
  const SplashFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: SplashConstants.footerBottomPadding,
      ),
      child: Opacity(
        opacity: 0.8,
        child: const SplashFooterRow(),
      ),
    );
  }
}

class SplashFooterRow extends StatelessWidget {
  const SplashFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SplashFooterText(),
        SizedBox(width: SplashConstants.footerIconSpacing),
        SplashFooterIcon(),
      ],
    );
  }
}

class SplashFooterText extends StatelessWidget {
  const SplashFooterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.splashFooter,
      style: AppTextStyles.p3Medium.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class SplashFooterIcon extends StatelessWidget {
  const SplashFooterIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.bolt,
      size: SplashConstants.footerIconSize,
      color: context.currentTheme.secondary,
    );
  }
}
