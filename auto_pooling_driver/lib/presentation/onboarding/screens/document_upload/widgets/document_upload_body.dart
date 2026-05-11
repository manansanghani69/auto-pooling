import 'package:auto_pooling_driver/constants/app_constants.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:auto_pooling_driver/presentation/onboarding/constants/onboarding_constants.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_app_bar.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_footer_action.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_header_copy.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_info_banner.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_progress_section.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_upload_placeholder.dart';
import 'package:auto_pooling_driver/routes.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentUploadBody extends StatelessWidget {
  const DocumentUploadBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (OnboardingState previous, OnboardingState current) =>
          previous.feedbackMessage != current.feedbackMessage ||
          previous.navigationTarget != current.navigationTarget,
      listener: (BuildContext context, OnboardingState state) {
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

        if (state.navigationTarget == OnboardingNavigationTarget.splash) {
          context.router.replaceAll(<PageRouteInfo<dynamic>>[
            const DriverSplashRoute(),
          ]);
          context.read<OnboardingBloc>().add(
            const OnboardingNavigationConsumedEvent(),
          );
        }
      },
      child: Scaffold(
        backgroundColor: context.currentTheme.backgroundPrimary,
        appBar: OnboardingAppBar(
          title: context.localization.onboardingUploadDocumentsTitle,
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
            child: const _DocumentUploadContent(),
          ),
        ),
        bottomNavigationBar: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (BuildContext context, OnboardingState state) {
            return Padding(
              padding: const EdgeInsets.all(OnboardingConstants.footerSpacing),
              child: OnboardingFooterAction(
                label: context.localization.onboardingSubmitDocumentsAction,
                isLoading: state.isSubmittingDocuments,
                onPressed: () {
                  context.read<OnboardingBloc>().add(
                    const OnboardingDocumentsSubmittedEvent(),
                  );
                },
                secondary: TextButton.icon(
                  onPressed: () {
                    context.read<OnboardingBloc>().add(
                      OnboardingFeedbackRequestedEvent(
                        message: context
                            .localization
                            .onboardingDocumentsPlaceholderMessage,
                      ),
                    );
                  },
                  icon: const Icon(Icons.help_outline_rounded),
                  label: Text(context.localization.onboardingGetHelpAction),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DocumentUploadContent extends StatelessWidget {
  const _DocumentUploadContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const OnboardingProgressSection(
          step: 3,
          totalSteps: OnboardingConstants.totalSteps,
        ),
        const SizedBox(height: OnboardingConstants.sectionSpacing),
        OnboardingHeaderCopy(
          title: context.localization.onboardingDocumentsHeadline,
          description: context.localization.onboardingDocumentsDescription,
        ),
        const SizedBox(height: OnboardingConstants.sectionSpacing),
        OnboardingUploadPlaceholder(
          title: context.localization.onboardingLicenseTitle,
          description: context.localization.onboardingLicenseDescription,
          actionLabel: context.localization.onboardingUploadLicenseAction,
          statusLabel: context.localization.onboardingPendingLabel,
          onTap: () {
            context.read<OnboardingBloc>().add(
              OnboardingFeedbackRequestedEvent(
                message:
                    context.localization.onboardingDocumentsPlaceholderMessage,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        OnboardingUploadPlaceholder(
          title: context.localization.onboardingVehicleRcTitle,
          description: context.localization.onboardingVehicleRcDescription,
          actionLabel: context.localization.onboardingUploadRcAction,
          statusLabel: context.localization.onboardingRequiredLabel,
          onTap: () {
            context.read<OnboardingBloc>().add(
              OnboardingFeedbackRequestedEvent(
                message:
                    context.localization.onboardingDocumentsPlaceholderMessage,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        OnboardingInfoBanner(
          message: context.localization.onboardingDocumentsPlaceholderMessage,
        ),
      ],
    );
  }
}
