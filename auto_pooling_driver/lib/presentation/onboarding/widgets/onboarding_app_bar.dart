import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class OnboardingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OnboardingAppBar({required this.title, this.onBackPressed, super.key});

  final String title;
  final VoidCallback? onBackPressed;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.currentTheme.backgroundSurface,
      surfaceTintColor: context.currentTheme.backgroundSurface.withValues(
        alpha: 0,
      ),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: onBackPressed ?? () => context.router.maybePop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      title: Text(
        title,
        style: AppTextStyles.h2Bold.copyWith(
          color: context.currentTheme.textNeutralPrimary,
        ),
      ),
    );
  }
}
