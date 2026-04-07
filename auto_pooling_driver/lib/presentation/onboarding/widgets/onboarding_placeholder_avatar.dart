import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class OnboardingPlaceholderAvatar extends StatelessWidget {
  const OnboardingPlaceholderAvatar({
    required this.label,
    required this.onTap,
    super.key,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: <Widget>[
              Container(
                width: 116,
                height: 116,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: <Color>[
                      context.currentTheme.highlightSurface,
                      context.currentTheme.backgroundPrimary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: context.currentTheme.backgroundSurface,
                    width: 4,
                  ),
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 52,
                  color: context.currentTheme.accentPrimary,
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: context.currentTheme.accentPrimary,
                  child: const Icon(
                    Icons.photo_camera_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: AppTextStyles.p3Medium.copyWith(
            color: context.currentTheme.accentPrimary,
          ),
        ),
      ],
    );
  }
}
