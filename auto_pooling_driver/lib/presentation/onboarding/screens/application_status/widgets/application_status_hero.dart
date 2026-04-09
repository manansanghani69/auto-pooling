import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:flutter/material.dart';

class ApplicationStatusHero extends StatelessWidget {
  const ApplicationStatusHero({required this.status, super.key});

  final DriverOnboardingStatus status;

  @override
  Widget build(BuildContext context) {
    final _ApplicationStatusCopy copy = _ApplicationStatusCopy.fromStatus(
      context,
      status,
    );

    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: context.currentTheme.highlightSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                copy.icon,
                size: 52,
                color: context.currentTheme.accentPrimary,
              ),
            ),
            Positioned(
              top: 2,
              right: 4,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: context.currentTheme.backgroundSurface,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: copy.pulseColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          copy.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.h1Bold.copyWith(
            color: context.currentTheme.textNeutralPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          copy.description,
          textAlign: TextAlign.center,
          style: AppTextStyles.p2Regular.copyWith(
            color: context.currentTheme.textNeutralSecondary,
          ),
        ),
      ],
    );
  }
}

class _ApplicationStatusCopy {
  const _ApplicationStatusCopy({
    required this.title,
    required this.description,
    required this.icon,
    required this.pulseColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color pulseColor;

  factory _ApplicationStatusCopy.fromStatus(
    BuildContext context,
    DriverOnboardingStatus status,
  ) {
    switch (status) {
      case DriverOnboardingStatus.documentsUploaded:
        return _ApplicationStatusCopy(
          title: context.localization.authStatusPendingTitle,
          description: context.localization.onboardingStatusPendingDescription,
          icon: Icons.hourglass_top_rounded,
          pulseColor: Colors.orange,
        );
      case DriverOnboardingStatus.rejected:
        return _ApplicationStatusCopy(
          title: context.localization.authStatusRejectedTitle,
          description: context.localization.authStatusRejectedDescription,
          icon: Icons.error_outline_rounded,
          pulseColor: Colors.redAccent,
        );
      case DriverOnboardingStatus.approved:
        return _ApplicationStatusCopy(
          title: context.localization.onboardingApprovedTitle,
          description: context.localization.onboardingApprovedDescription,
          icon: Icons.verified_rounded,
          pulseColor: Colors.green,
        );
      case DriverOnboardingStatus.infoRemaining:
      case DriverOnboardingStatus.unknown:
        return _ApplicationStatusCopy(
          title: context.localization.authStatusUnknownTitle,
          description: context.localization.authStatusUnknownDescription,
          icon: Icons.help_outline_rounded,
          pulseColor: Colors.grey,
        );
    }
  }
}
