import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/theme/text_style/app_text_styles.dart';
import '../../../i18n/localization.dart';
import '../../../widgets/styling/app_colors.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../constants/onboarding_constants.dart';

class OnboardingBody extends StatelessWidget {
  final PageController pageController;
  final VoidCallback onSkip;
  final VoidCallback onContinue;

  const OnboardingBody({
    required this.pageController,
    required this.onSkip,
    required this.onContinue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          OnboardingHeader(onSkip: onSkip),
          Expanded(child: OnboardingPageView(controller: pageController)),
          OnboardingFooter(onContinue: onContinue),
        ],
      ),
    );
  }
}

class OnboardingHeader extends StatelessWidget {
  final VoidCallback onSkip;

  const OnboardingHeader({required this.onSkip, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        OnboardingConstants.horizontalPadding,
        OnboardingConstants.headerTopPadding,
        OnboardingConstants.horizontalPadding,
        OnboardingConstants.headerBottomPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [OnboardingSkipButton(onPressed: onSkip)],
      ),
    );
  }
}

class OnboardingSkipButton extends StatelessWidget {
  final VoidCallback onPressed;

  const OnboardingSkipButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        foregroundColor: context.currentTheme.textNeutralSecondary,
        shape: const StadiumBorder(),
      ),
      child: const OnboardingSkipButtonLabel(),
    );
  }
}

class OnboardingSkipButtonLabel extends StatelessWidget {
  const OnboardingSkipButtonLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.onboardingSkip,
      style: AppTextStyles.p3Medium.copyWith(
        color: context.currentTheme.textNeutralSecondary,
        letterSpacing: 0.4,
      ),
    );
  }
}

class OnboardingPageView extends StatelessWidget {
  final PageController controller;

  const OnboardingPageView({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      onPageChanged: (index) {
        context.read<OnboardingBloc>().add(
          OnboardingPageChangedEvent(index: index),
        );
      },
      children: const [
        OnboardingPageOne(),
        OnboardingPageTwo(),
        OnboardingPageThree(),
      ],
    );
  }
}

class OnboardingPageOne extends StatelessWidget {
  const OnboardingPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageContent(
      title: context.localization.onboardingPageOneTitle,
      subtitle: context.localization.onboardingPageOneSubtitle,
      badgeLabel: context.localization.onboardingBadgeSavedLabel,
      badgeValue: context.localization.onboardingBadgeSavedValue,
      badgeIcon: Icons.savings,
      imageUrl: OnboardingConstants.heroImageUrl,
    );
  }
}

class OnboardingPageTwo extends StatelessWidget {
  const OnboardingPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageContent(
      title: context.localization.onboardingPageTwoTitle,
      subtitle: context.localization.onboardingPageTwoSubtitle,
      badgeLabel: context.localization.onboardingBadgeYourRide,
      badgeValue: context.localization.onboardingBadgeYourRideValue,
      badgeIcon: Icons.verified_user,
      imageUrl: OnboardingConstants.heroImageUrl,
    );
  }
}

class OnboardingPageThree extends StatelessWidget {
  const OnboardingPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageContent(
      title: context.localization.onboardingPageThreeTitle,
      subtitle: context.localization.onboardingPageThreeSubtitle,
      badgeLabel: context.localization.onboardingBadgeVerifiedLabel,
      badgeValue: context.localization.onboardingBadgeVerifiedValues,
      badgeIcon: Icons.map,
      imageUrl: OnboardingConstants.heroImageUrl,
    );
  }
}

class OnboardingPageContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeLabel;
  final String badgeValue;
  final IconData badgeIcon;
  final String imageUrl;

  const OnboardingPageContent({
    required this.title,
    required this.subtitle,
    required this.badgeLabel,
    required this.badgeValue,
    required this.badgeIcon,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: OnboardingConstants.horizontalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OnboardingHeroSection(
            imageUrl: imageUrl,
            badgeLabel: badgeLabel,
            badgeValue: badgeValue,
            badgeIcon: badgeIcon,
          ),
          const SizedBox(height: OnboardingConstants.heroTextSpacing),
          OnboardingTextSection(title: title, subtitle: subtitle),
        ],
      ),
    );
  }
}

class OnboardingHeroSection extends StatelessWidget {
  final String imageUrl;
  final String badgeLabel;
  final String badgeValue;
  final IconData badgeIcon;

  const OnboardingHeroSection({
    required this.imageUrl,
    required this.badgeLabel,
    required this.badgeValue,
    required this.badgeIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: OnboardingConstants.heroMaxWidth,
      ),
      child: AspectRatio(
        aspectRatio: OnboardingConstants.heroAspectRatio,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const OnboardingHeroGlowBackground(),
            OnboardingHeroImage(imageUrl: imageUrl, color: Colors.white),
            OnboardingHeroBadgePositioned(
              label: badgeLabel,
              value: badgeValue,
              icon: badgeIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingHeroGlowBackground extends StatelessWidget {
  const OnboardingHeroGlowBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(child: OnboardingHeroGlowLayer());
  }
}

class OnboardingHeroGlowLayer extends StatelessWidget {
  const OnboardingHeroGlowLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Stack(
        alignment: Alignment.center,
        children: [
          OnboardingHeroGlowCircle(
            size: OnboardingConstants.heroGlowPrimarySize,
            color: context.currentTheme.primary.withAlpha(20),
          ),
          const OnboardingHeroGlowOffset(child: OnboardingHeroSecondaryGlow()),
        ],
      ),
    );
  }
}

class OnboardingHeroSecondaryGlow extends StatelessWidget {
  const OnboardingHeroSecondaryGlow({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingHeroGlowCircle(
      size: OnboardingConstants.heroGlowSecondarySize,
      color: context.currentTheme.secondary.withAlpha(30),
    );
  }
}

class OnboardingHeroGlowOffset extends StatelessWidget {
  final Widget child;

  const OnboardingHeroGlowOffset({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(
        OnboardingConstants.heroGlowOffset,
        OnboardingConstants.heroGlowOffset,
      ),
      child: child,
    );
  }
}

class OnboardingHeroGlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const OnboardingHeroGlowCircle({
    required this.size,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [BoxShadow(color: color, blurRadius: 40.0)],
        ),
      ),
    );
  }
}

class OnboardingHeroImage extends StatelessWidget {
  final String imageUrl;
  final Color color;

  const OnboardingHeroImage({
    required this.imageUrl,
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 5),
          borderRadius: BorderRadius.circular(
            OnboardingConstants.heroImageBorderRadius,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: OnboardingConstants.heroShadowBlur,
              offset: const Offset(0, OnboardingConstants.heroShadowOffsetY),
            ),
          ],
        ),
        child: OnboardingHeroImageCard(imageUrl: imageUrl),
      ),
    );
  }
}

class OnboardingHeroImageCard extends StatelessWidget {
  final String imageUrl;

  const OnboardingHeroImageCard({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          OnboardingConstants.heroImageRadius,
        ),
      ),
      child: OnboardingHeroImageClip(imageUrl: imageUrl),
    );
  }
}

class OnboardingHeroImageClip extends StatelessWidget {
  final String imageUrl;

  const OnboardingHeroImageClip({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(OnboardingConstants.heroImageRadius),
      child: OnboardingHeroImageStack(imageUrl: imageUrl),
    );
  }
}

class OnboardingHeroImageStack extends StatelessWidget {
  final String imageUrl;

  const OnboardingHeroImageStack({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OnboardingHeroImageBackground(imageUrl: imageUrl),
        const OnboardingHeroImageOverlay(),
      ],
    );
  }
}

class OnboardingHeroImageBackground extends StatelessWidget {
  final String imageUrl;

  const OnboardingHeroImageBackground({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class OnboardingHeroImageOverlay extends StatelessWidget {
  const OnboardingHeroImageOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              context.currentTheme.backgroundPrimary.withOpacity(0.2),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingHeroBadgePositioned extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const OnboardingHeroBadgePositioned({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: OnboardingConstants.heroBadgeBottomOffset,
      right: OnboardingConstants.heroBadgeRightOffset,
      child: OnboardingHeroBadge(label: label, value: value, icon: icon),
    );
  }
}

class OnboardingHeroBadge extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const OnboardingHeroBadge({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.currentTheme.backgroundPrimary,
        borderRadius: BorderRadius.circular(
          OnboardingConstants.heroBadgeRadius,
        ),
        border: Border.all(
          color: context.currentTheme.textNeutralSecondary.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(OnboardingConstants.heroBadgePadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OnboardingBadgeIconBox(icon: icon),
            const SizedBox(width: OnboardingConstants.heroBadgeSpacing),
            OnboardingBadgeTextColumn(label: label, value: value),
          ],
        ),
      ),
    );
  }
}

class OnboardingBadgeIconBox extends StatelessWidget {
  final IconData icon;

  const OnboardingBadgeIconBox({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.currentTheme.secondary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(
          OnboardingConstants.heroBadgeIconRadius,
        ),
      ),
      child: SizedBox(
        width: OnboardingConstants.heroBadgeIconBoxSize,
        height: OnboardingConstants.heroBadgeIconBoxSize,
        child: Center(child: OnboardingBadgeIcon(icon: icon)),
      ),
    );
  }
}

class OnboardingBadgeIcon extends StatelessWidget {
  final IconData icon;

  const OnboardingBadgeIcon({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: OnboardingConstants.heroBadgeIconSize,
      color: context.currentTheme.secondary,
    );
  }
}

class OnboardingBadgeTextColumn extends StatelessWidget {
  final String label;
  final String value;

  const OnboardingBadgeTextColumn({
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingBadgeLabel(text: label),
        const SizedBox(height: OnboardingConstants.badgeLabelSpacing),
        OnboardingBadgeValue(text: value),
      ],
    );
  }
}

class OnboardingBadgeLabel extends StatelessWidget {
  final String text;

  const OnboardingBadgeLabel({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.p3Medium.copyWith(
        fontSize: OnboardingConstants.badgeLabelFontSize,
        letterSpacing: OnboardingConstants.badgeLabelLetterSpacing,
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class OnboardingBadgeValue extends StatelessWidget {
  final String text;

  const OnboardingBadgeValue({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.p3Medium.copyWith(
        fontSize: OnboardingConstants.badgeValueFontSize,
        fontWeight: FontWeight.w700,
        color: context.currentTheme.primary,
      ),
    );
  }
}

class OnboardingTextSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const OnboardingTextSection({
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: OnboardingConstants.heroMaxWidth,
      ),
      child: Column(
        children: [
          OnboardingTitleText(text: title),
          const SizedBox(height: OnboardingConstants.textSectionSpacing),
          OnboardingSubtitleText(text: subtitle),
        ],
      ),
    );
  }
}

class OnboardingTitleText extends StatelessWidget {
  final String text;

  const OnboardingTitleText({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.h2SemiBold.copyWith(
        fontSize: OnboardingConstants.titleFontSize,
        fontWeight: FontWeight.w700,
        color: context.currentTheme.textNeutralPrimary,
        height: 1.2,
      ),
    );
  }
}

class OnboardingSubtitleText extends StatelessWidget {
  final String text;

  const OnboardingSubtitleText({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.p2Regular.copyWith(
        fontSize: OnboardingConstants.subtitleFontSize,
        color: context.currentTheme.textNeutralSecondary,
        height: 1.5,
      ),
    );
  }
}

class OnboardingFooter extends StatelessWidget {
  final VoidCallback onContinue;

  const OnboardingFooter({required this.onContinue, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        OnboardingConstants.horizontalPadding,
        OnboardingConstants.footerTopPadding,
        OnboardingConstants.horizontalPadding,
        OnboardingConstants.footerBottomPadding,
      ),
      child: Column(
        children: [
          const OnboardingIndicatorRow(),
          const SizedBox(height: OnboardingConstants.footerContentSpacing),
          OnboardingContinueButton(onPressed: onContinue),
        ],
      ),
    );
  }
}

class OnboardingIndicatorRow extends StatelessWidget {
  const OnboardingIndicatorRow({super.key});

  @override
  Widget build(BuildContext context) {
    final int currentPage = context.select<OnboardingBloc, int>(
      (bloc) => bloc.state.currentPage,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OnboardingPageIndicator(isActive: currentPage == 0),
        const SizedBox(width: OnboardingConstants.indicatorSpacing),
        OnboardingPageIndicator(isActive: currentPage == 1),
        const SizedBox(width: OnboardingConstants.indicatorSpacing),
        OnboardingPageIndicator(isActive: currentPage == 2),
      ],
    );
  }
}

class OnboardingPageIndicator extends StatelessWidget {
  final bool isActive;

  const OnboardingPageIndicator({required this.isActive, super.key});

  @override
  Widget build(BuildContext context) {
    final double width = isActive
        ? OnboardingConstants.indicatorActiveWidth
        : OnboardingConstants.indicatorInactiveSize;
    final Color color = isActive
        ? context.currentTheme.primary
        : context.currentTheme.textNeutralSecondary.withOpacity(0.25);

    return AnimatedContainer(
      duration: OnboardingConstants.indicatorAnimationDuration,
      width: width,
      height: OnboardingConstants.indicatorHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          OnboardingConstants.indicatorHeight,
        ),
      ),
    );
  }
}

class OnboardingContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  const OnboardingContinueButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: OnboardingConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.currentTheme.primary,
          foregroundColor: Colors.white,
          elevation: 4.0,
          shadowColor: context.currentTheme.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              OnboardingConstants.buttonRadius,
            ),
          ),
        ),
        child: const OnboardingContinueButtonContent(),
      ),
    );
  }
}

class OnboardingContinueButtonContent extends StatelessWidget {
  const OnboardingContinueButtonContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const OnboardingContinueButtonLabel(),
        const SizedBox(width: OnboardingConstants.buttonIconSpacing),
        const OnboardingContinueButtonIcon(),
      ],
    );
  }
}

class OnboardingContinueButtonLabel extends StatelessWidget {
  const OnboardingContinueButtonLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.onboardingContinue,
      style: AppTextStyles.p2Regular.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class OnboardingContinueButtonIcon extends StatelessWidget {
  const OnboardingContinueButtonIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_forward,
      size: OnboardingConstants.buttonIconSize,
      color: Colors.white,
    );
  }
}
