import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class OnboardingUploadPlaceholder extends StatelessWidget {
  const OnboardingUploadPlaceholder({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onTap,
    this.statusLabel,
    super.key,
  });

  final String title;
  final String description;
  final String actionLabel;
  final String? statusLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.currentTheme.backgroundSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.currentTheme.strokeSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: AppTextStyles.p1Medium.copyWith(
                        color: context.currentTheme.textNeutralPrimary,
                      ),
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
              if (statusLabel != null)
                Chip(
                  label: Text(statusLabel!),
                  side: BorderSide.none,
                  backgroundColor: context.currentTheme.highlightSurface,
                ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.upload_file_rounded),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
