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
          previous.failure != current.failure,
      listener: (BuildContext context, OnboardingState state) {
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
        bottomNavigationBar: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (BuildContext context, OnboardingState state) {
            return Padding(
              padding: const EdgeInsets.all(OnboardingConstants.footerSpacing),
              child: OnboardingFooterAction(
                label: context.localization.onboardingSaveContinueAction,
                onPressed: state.canSubmitVehicleDetails
                    ? () {
                        context.read<OnboardingBloc>().add(
                          const OnboardingProfileSubmittedEvent(),
                        );
                      }
                    : null,
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
              style: Theme.of(context).textTheme.labelLarge,
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
            const SizedBox(height: OnboardingConstants.sectionSpacing),
            OnboardingTextField(
              label: context.localization.onboardingRegistrationNumberLabel,
              initialValue: state.vehicleRegistrationNumber,
              hintText: context.localization.onboardingRegistrationNumberHint,
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
              style: Theme.of(context).textTheme.labelLarge,
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
              onTap: () => _showUploadPlaceholder(context),
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

  void _showUploadPlaceholder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.localization.onboardingVehiclePhotoPlaceholderMessage,
        ),
      ),
    );
  }
}
