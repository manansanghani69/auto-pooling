import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class HomeAppBarTitle extends StatelessWidget {
  const HomeAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        HomeAppBarIcon(),
        SizedBox(width: 12),
        HomeAppBarLabel(),
      ],
    );
  }
}

class HomeAppBarIcon extends StatelessWidget {
  const HomeAppBarIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Assets.icons.appMark.svg(
      width: 24,
      height: 24,
    );
  }
}

class HomeAppBarLabel extends StatelessWidget {
  const HomeAppBarLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.homeTitle,
      style: AppTextStyles.h2Bold.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}
