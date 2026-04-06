import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/constants/app_constants.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/presentation/home/bloc/home_bloc.dart';
import 'package:auto_pooling_driver/presentation/home/domain/entities/dashboard_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStatList extends StatelessWidget {
  const HomeStatList({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardSummary? summary = context.select<HomeBloc, DashboardSummary?>(
      (HomeBloc bloc) => bloc.state.summary,
    );

    if (summary == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: <Widget>[
        HomeStatTile(
          label: context.localization.homeActiveTrips,
          value: summary.activeTrips.toString(),
        ),
        const SizedBox(height: AppConstants.tileSpacing),
        HomeStatTile(
          label: context.localization.homeCompletedTrips,
          value: summary.completedTrips.toString(),
        ),
        const SizedBox(height: AppConstants.tileSpacing),
        HomeStatTile(
          label: context.localization.homeTodayEarnings,
          value: summary.todayEarnings.toString(),
        ),
      ],
    );
  }
}

class HomeStatTile extends StatelessWidget {
  const HomeStatTile({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.currentTheme.backgroundSurface,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(color: context.currentTheme.strokeSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Row(
          children: <Widget>[
            Expanded(child: HomeStatLabel(label: label)),
            const SizedBox(width: 16),
            HomeStatValue(value: value),
          ],
        ),
      ),
    );
  }
}

class HomeStatLabel extends StatelessWidget {
  const HomeStatLabel({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.p2Regular.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class HomeStatValue extends StatelessWidget {
  const HomeStatValue({
    required this.value,
    super.key,
  });

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: AppTextStyles.h2Bold.copyWith(
        color: context.currentTheme.accentPrimary,
      ),
    );
  }
}
