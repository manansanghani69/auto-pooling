import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:flutter/material.dart';

class ApplicationStatusTimeline extends StatelessWidget {
  const ApplicationStatusTimeline({required this.status, super.key});

  final DriverOnboardingStatus status;

  @override
  Widget build(BuildContext context) {
    final bool documentsDone =
        status == DriverOnboardingStatus.documentsUploaded ||
        status == DriverOnboardingStatus.approved;
    final bool reviewCurrent =
        status == DriverOnboardingStatus.documentsUploaded;
    final bool approvedDone = status == DriverOnboardingStatus.approved;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.localization.onboardingStepsLabel,
          style: AppTextStyles.p3Medium.copyWith(
            color: context.currentTheme.textNeutralSecondary,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 20),
        _TimelineRow(
          isDone: documentsDone,
          isCurrent: false,
          title: context.localization.onboardingTimelineDocumentsTitle,
          description:
              context.localization.onboardingTimelineDocumentsDescription,
        ),
        _TimelineRow(
          isDone: approvedDone,
          isCurrent: reviewCurrent,
          title: context.localization.onboardingTimelineReviewTitle,
          description: context.localization.onboardingTimelineReviewDescription,
          badgeLabel: reviewCurrent
              ? context.localization.onboardingCurrentLabel
              : null,
        ),
        _TimelineRow(
          isDone: approvedDone,
          isCurrent: false,
          title: context.localization.onboardingTimelineApprovalTitle,
          description:
              context.localization.onboardingTimelineApprovalDescription,
          isLast: true,
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.isDone,
    required this.isCurrent,
    required this.title,
    required this.description,
    this.badgeLabel,
    this.isLast = false,
  });

  final bool isDone;
  final bool isCurrent;
  final bool isLast;
  final String title;
  final String description;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    final Color markerColor = isDone || isCurrent
        ? context.currentTheme.accentPrimary
        : context.currentTheme.strokeSubtle;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 32,
            child: Column(
              children: <Widget>[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDone
                        ? markerColor
                        : isCurrent
                        ? context.currentTheme.backgroundSurface
                        : context.currentTheme.highlightSurface,
                    shape: BoxShape.circle,
                    border: Border.all(color: markerColor, width: 2),
                  ),
                  child: Icon(
                    isDone
                        ? Icons.check_rounded
                        : isCurrent
                        ? Icons.schedule_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 16,
                    color: isDone ? Colors.white : markerColor,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: context.currentTheme.strokeSubtle,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.p1Medium.copyWith(
                            color: isCurrent
                                ? context.currentTheme.accentPrimary
                                : context.currentTheme.textNeutralPrimary,
                          ),
                        ),
                      ),
                      if (badgeLabel != null)
                        Chip(
                          label: Text(badgeLabel!),
                          side: BorderSide.none,
                          backgroundColor:
                              context.currentTheme.highlightSurface,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.p2Regular.copyWith(
                      color: context.currentTheme.textNeutralSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
