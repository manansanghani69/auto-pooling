import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/constants/app_constants.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/gen/assets.gen.dart';
import 'package:auto_pooling_driver/presentation/home/bloc/home_bloc.dart';
import 'package:auto_pooling_driver/presentation/home/bloc/home_event.dart';
import 'package:auto_pooling_driver/presentation/home/constants/home_layout.dart';
import 'package:auto_pooling_driver/presentation/home/widgets/home_stat_tile.dart';
import 'package:auto_pooling_driver/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeDashboardContent extends StatelessWidget {
  const HomeDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HomeDashboardIllustration(),
          SizedBox(height: AppConstants.sectionSpacing),
          HomeHeadlineGroup(),
          SizedBox(height: AppConstants.sectionSpacing),
          HomeStatList(),
          SizedBox(height: AppConstants.sectionSpacing),
          HomeRefreshButton(),
        ],
      ),
    );
  }
}

class HomeDashboardIllustration extends StatelessWidget {
  const HomeDashboardIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Assets.images.dashboardIllustration.svg(
        height: HomeLayout.illustrationHeight,
      ),
    );
  }
}

class HomeHeadlineGroup extends StatelessWidget {
  const HomeHeadlineGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HomeHeadline(),
        SizedBox(height: HomeLayout.headerSpacing),
        HomeSubtitle(),
      ],
    );
  }
}

class HomeHeadline extends StatelessWidget {
  const HomeHeadline({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.homeHeadline,
      style: AppTextStyles.h1Bold.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class HomeSubtitle extends StatelessWidget {
  const HomeSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.homeSubtitle,
      style: AppTextStyles.p2Regular.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class HomeRefreshButton extends StatelessWidget {
  const HomeRefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: context.localization.homeRefreshAction,
      onPressed: () {
        context.read<HomeBloc>().add(const HomeStartedEvent());
      },
    );
  }
}
