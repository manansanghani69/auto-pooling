import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/constants/app_constants.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/core/extensions/failure_x.dart';
import 'package:auto_pooling_driver/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:auto_pooling_driver/presentation/onboarding/constants/onboarding_constants.dart';
import 'package:auto_pooling_driver/presentation/onboarding/screens/vehicle_details/widgets/vehicle_details_photo_placeholder.dart';
import 'package:auto_pooling_driver/presentation/onboarding/screens/vehicle_details/widgets/vehicle_details_type_grid.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_app_bar.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_footer_action.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_header_copy.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_info_banner.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_passenger_capacity_card.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_progress_section.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_text_field.dart';
import 'package:auto_pooling_driver/routes.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleDetailsBody extends StatelessWidget {
  const VehicleDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (OnboardingState previous, OnboardingState current) =>
          previous.profileSubmissionStatus != current.profileSubmissionStatus ||
          previous.failure != current.failure ||
          previous.feedbackMessage != current.feedbackMessage,
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

        if (state.profileSubmissionStatus ==
            OnboardingSubmissionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.feedbackMessage ??
                    context.localization.onboardingVehicleSaveSuccess,
              ),
            ),
          );
          context.replaceRoute(const DriverOnboardingDocumentUploadRoute());
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
          title: context.localization.onboardingVehicleDetailsTitle,
        ),
        body: SafeArea(
          top: false,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.screenHorizontalPadding,
                8,
                AppConstants.screenHorizontalPadding,
                120,
              ),
              child: const _VehicleDetailsContent(),
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (BuildContext context, OnboardingState state) {
            return Padding(
              padding: const EdgeInsets.all(OnboardingConstants.footerSpacing),
              child: OnboardingFooterAction(
                label: context.localization.onboardingSaveContinueAction,
                isLoading: state.isSubmittingProfile,
                onPressed: () {
                  context.read<OnboardingBloc>().add(
                    const OnboardingProfileSubmittedEvent(),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _VehicleDetailsContent extends StatelessWidget {
  const _VehicleDetailsContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (BuildContext context, OnboardingState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const OnboardingProgressSection(
              step: 2,
              totalSteps: OnboardingConstants.totalSteps,
            ),
            const SizedBox(height: OnboardingConstants.sectionSpacing),
            OnboardingHeaderCopy(
              title: context.localization.onboardingVehicleHeadline,
              description: context.localization.onboardingVehicleDescription,
              leadingIcon: Icons.directions_car_filled_rounded,
            ),
            const SizedBox(height: OnboardingConstants.sectionSpacing),
            Text(
              context.localization.onboardingVehicleTypeLabel,
              style: AppTextStyles.p3Medium.copyWith(
                color: context.currentTheme.textNeutralSecondary,
              ),
            ),
            const SizedBox(height: 12),
            VehicleDetailsTypeGrid(
              selectedVehicleType: state.vehicleType,
              onVehicleTypeSelected: (String vehicleType) {
                context.read<OnboardingBloc>().add(
                  OnboardingVehicleTypeChangedEvent(vehicleType: vehicleType),
                );
              },
            ),
            if (state.showVehicleValidationErrors &&
                state.vehicleType.trim().isEmpty) ...<Widget>[
              const SizedBox(height: 8),
              VehicleDetailsValidationError(
                message: context.localization.commonValidationFailure,
              ),
            ],
            const SizedBox(height: OnboardingConstants.sectionSpacing),
            OnboardingTextField(
              label: context.localization.onboardingRegistrationNumberLabel,
              initialValue: state.vehicleRegistrationNumber,
              hintText: context.localization.onboardingRegistrationNumberHint,
              errorText:
                  state.showVehicleValidationErrors &&
                      state.vehicleRegistrationNumber.trim().isEmpty
                  ? context.localization.commonValidationFailure
                  : null,
              onChanged: (String value) {
                context.read<OnboardingBloc>().add(
                  OnboardingVehicleRegistrationChangedEvent(
                    registrationNumber: value,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              context.localization.onboardingAvailableSeatsLabel,
              style: AppTextStyles.p3Medium.copyWith(
                color: context.currentTheme.textNeutralSecondary,
              ),
            ),
            const SizedBox(height: 8),
            OnboardingPassengerCapacityCard(
              capacity: state.passengerCapacity,
              onDecrement: () {
                context.read<OnboardingBloc>().add(
                  const OnboardingPassengerCapacityDecrementedEvent(),
                );
              },
              onIncrement: () {
                context.read<OnboardingBloc>().add(
                  const OnboardingPassengerCapacityIncrementedEvent(),
                );
              },
            ),
            const SizedBox(height: 16),
            VehicleDetailsPhotoPlaceholder(
              onTap: () {
                context.read<OnboardingBloc>().add(
                  OnboardingFeedbackRequestedEvent(
                    message: context
                        .localization
                        .onboardingVehiclePhotoPlaceholderMessage,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            OnboardingInfoBanner(
              message:
                  context.localization.onboardingVehiclePhotoPlaceholderMessage,
            ),
          ],
        );
      },
    );
  }
}

class VehicleDetailsValidationError extends StatelessWidget {
  const VehicleDetailsValidationError({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: AppTextStyles.p3Medium.copyWith(
        color: context.currentTheme.accentSecondary,
      ),
    );
  }
}
