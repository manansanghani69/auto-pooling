import 'package:auto_pooling_driver/constants/app_constants.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/core/extensions/failure_x.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:auto_pooling_driver/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:auto_pooling_driver/presentation/onboarding/screens/application_status/widgets/application_status_hero.dart';
import 'package:auto_pooling_driver/presentation/onboarding/screens/application_status/widgets/application_status_timeline.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_app_bar.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_footer_action.dart';
import 'package:auto_pooling_driver/routes.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicationStatusBody extends StatelessWidget {
  const ApplicationStatusBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (OnboardingState previous, OnboardingState current) =>
          previous.statusRefreshStatus != current.statusRefreshStatus ||
          previous.onboardingStatus != current.onboardingStatus ||
          previous.failure != current.failure ||
          previous.feedbackMessage != current.feedbackMessage,
      listener: (BuildContext context, OnboardingState state) {
        if (state.onboardingStatus == DriverOnboardingStatus.approved) {
          context.router.replaceAll(<PageRouteInfo<dynamic>>[
            const DriverSplashRoute(),
          ]);
          return;
        }

        final String? feedbackMessage = state.feedbackMessage;
        if (feedbackMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(feedbackMessage)));
          context.read<OnboardingBloc>().add(
            const OnboardingFeedbackConsumedEvent(),
          );
          return;
        }

        final failure = state.failure;
        if (failure == null) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.resolveMessage(context.localization))),
        );
      },
      child: Scaffold(
        backgroundColor: context.currentTheme.backgroundPrimary,
        appBar: OnboardingAppBar(
          title: context.localization.onboardingApplicationStatusTitle,
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.screenHorizontalPadding,
              8,
              AppConstants.screenHorizontalPadding,
              120,
            ),
            child: const _ApplicationStatusContent(),
          ),
        ),
        bottomNavigationBar: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (BuildContext context, OnboardingState state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: OnboardingFooterAction(
                label: context.localization.onboardingRefreshStatusAction,
                isLoading: state.isRefreshingStatus,
                onPressed: state.isRefreshingStatus
                    ? null
                    : () {
                        context.read<OnboardingBloc>().add(
                          const OnboardingStatusRefreshRequestedEvent(),
                        );
                      },
                secondary: TextButton(
                  onPressed: () {
                    context.read<OnboardingBloc>().add(
                      OnboardingFeedbackRequestedEvent(
                        message: context
                            .localization
                            .onboardingSupportPlaceholderMessage,
                      ),
                    );
                  },
                  child: Text(context.localization.onboardingSupportAction),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ApplicationStatusContent extends StatelessWidget {
  const _ApplicationStatusContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (BuildContext context, OnboardingState state) {
        return Column(
          children: <Widget>[
            ApplicationStatusHero(status: state.onboardingStatus),
            const SizedBox(height: 32),
            Divider(color: context.currentTheme.strokeSubtle),
            const SizedBox(height: 24),
            ApplicationStatusTimeline(status: state.onboardingStatus),
          ],
        );
      },
    );
  }
}
