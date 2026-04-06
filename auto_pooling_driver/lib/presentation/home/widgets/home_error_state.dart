import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/constants/app_constants.dart';
import 'package:auto_pooling_driver/core/errors/failures.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/core/extensions/failure_type_x.dart';
import 'package:auto_pooling_driver/presentation/home/bloc/home_bloc.dart';
import 'package:auto_pooling_driver/presentation/home/bloc/home_event.dart';
import 'package:auto_pooling_driver/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeErrorState extends StatelessWidget {
  const HomeErrorState({super.key});

  @override
  Widget build(BuildContext context) {
    final Failure? failure = context.select<HomeBloc, Failure?>(
      (HomeBloc bloc) => bloc.state.failure,
    );

    final String description =
        failure?.type.resolveMessage(context.localization) ??
        context.localization.homeErrorDescription;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const HomeErrorTitle(),
            const SizedBox(height: 12),
            HomeErrorDescription(description: description),
            const SizedBox(height: 20),
            const HomeRetryButton(),
          ],
        ),
      ),
    );
  }
}

class HomeErrorTitle extends StatelessWidget {
  const HomeErrorTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.homeErrorTitle,
      textAlign: TextAlign.center,
      style: AppTextStyles.h2Bold.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class HomeErrorDescription extends StatelessWidget {
  const HomeErrorDescription({
    required this.description,
    super.key,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      textAlign: TextAlign.center,
      style: AppTextStyles.p2Regular.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class HomeRetryButton extends StatelessWidget {
  const HomeRetryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: context.localization.homeRetryAction,
      onPressed: () {
        context.read<HomeBloc>().add(const HomeRetryRequestedEvent());
      },
    );
  }
}
