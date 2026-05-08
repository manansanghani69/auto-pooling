import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../common/theme/text_style/app_text_styles.dart';
import '../../../i18n/localization.dart';
import '../../../routes.dart';
import '../../../widgets/styling/app_colors.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: HomeContent(),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [HomeHeader(), SizedBox(height: 24.0), HomeActionList()],
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.appTitle,
      style: AppTextStyles.h2SemiBold.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class HomeActionList extends StatelessWidget {
  const HomeActionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeActionTile(
          title: context.localization.rideRequestTitle,
          subtitle: context.localization.rideRequestSubtitle,
          icon: Icons.local_taxi,
          onTap: () => context.pushRoute(const RideRequestRoute()),
        ),
        const SizedBox(height: 12.0),
        HomeActionTile(
          title: context.localization.profileTitle,
          subtitle: context.localization.profileSubtitle,
          icon: Icons.person,
          onTap: () => context.pushRoute(ProfileRoute(isEditing: true)),
        ),
        const SizedBox(height: 12.0),
        HomeActionTile(
          title: context.localization.paymentsTitle,
          subtitle: context.localization.paymentsSubtitle,
          icon: Icons.payments,
          onTap: () => context.pushRoute(const PaymentsRoute()),
        ),
        const SizedBox(height: 12.0),
        HomeActionTile(
          title: context.localization.notificationsTitle,
          subtitle: context.localization.notificationsSubtitle,
          icon: Icons.notifications,
          onTap: () => context.pushRoute(const NotificationsRoute()),
        ),
      ],
    );
  }
}

class HomeActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const HomeActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.currentTheme.backgroundPrimary,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: context.currentTheme.textNeutralSecondary.withAlpha(51),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                HomeActionIcon(icon: icon),
                const SizedBox(width: 12.0),
                Expanded(
                  child: HomeActionText(title: title, subtitle: subtitle),
                ),
                const HomeActionChevron(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeActionIcon extends StatelessWidget {
  final IconData icon;

  const HomeActionIcon({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 24.0, color: context.currentTheme.primary);
  }
}

class HomeActionText extends StatelessWidget {
  final String title;
  final String subtitle;

  const HomeActionText({
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeActionTitle(text: title),
        const SizedBox(height: 4.0),
        HomeActionSubtitle(text: subtitle),
      ],
    );
  }
}

class HomeActionTitle extends StatelessWidget {
  final String text;

  const HomeActionTitle({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.p2Regular.copyWith(
        fontWeight: FontWeight.w700,
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class HomeActionSubtitle extends StatelessWidget {
  final String text;

  const HomeActionSubtitle({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.p3Medium.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class HomeActionChevron extends StatelessWidget {
  const HomeActionChevron({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_right,
      color: context.currentTheme.textNeutralSecondary,
    );
  }
}
