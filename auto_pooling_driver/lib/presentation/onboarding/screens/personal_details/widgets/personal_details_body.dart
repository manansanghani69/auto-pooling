import 'package:auto_pooling_driver/constants/app_constants.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/core/extensions/failure_x.dart';
import 'package:auto_pooling_driver/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:auto_pooling_driver/presentation/onboarding/constants/onboarding_constants.dart';
import 'package:auto_pooling_driver/presentation/onboarding/screens/personal_details/widgets/personal_details_date_field.dart';
import 'package:auto_pooling_driver/presentation/onboarding/screens/personal_details/widgets/personal_details_gender_group.dart';
import 'package:auto_pooling_driver/presentation/onboarding/screens/personal_details/widgets/personal_details_profile_photo.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_app_bar.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_error_state.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_footer_action.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_header_copy.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_info_banner.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_loading_state.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_progress_section.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_read_only_field.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_text_field.dart';
import 'package:auto_pooling_driver/routes.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalDetailsBody extends StatelessWidget {
  const PersonalDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (OnboardingState previous, OnboardingState current) =>
          previous.failure != current.failure ||
          previous.feedbackMessage != current.feedbackMessage ||
          previous.datePickerRequestCount != current.datePickerRequestCount ||
          previous.navigationTarget != current.navigationTarget,
      listener: (BuildContext context, OnboardingState state) {
        if (state.navigationTarget ==
            OnboardingNavigationTarget.vehicleDetails) {
          context.pushRoute(
            DriverOnboardingVehicleDetailsRoute(
              onboardingBloc: context.read<OnboardingBloc>(),
            ),
          );
          context.read<OnboardingBloc>().add(
            const OnboardingNavigationConsumedEvent(),
          );
          return;
        }

        if (state.datePickerRequestCount > 0) {
          _selectDate(context, state.dateOfBirth);
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
          title: context.localization.onboardingPersonalDetailsTitle,
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
              child: const _PersonalDetailsContent(),
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (BuildContext context, OnboardingState state) {
            return Padding(
              padding: const EdgeInsets.all(OnboardingConstants.footerSpacing),
              child: OnboardingFooterAction(
                label: context.localization.onboardingSaveContinueAction,
                onPressed: () {
                  context.read<OnboardingBloc>().add(
                    const OnboardingPersonalDetailsContinueRequestedEvent(),
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

class _PersonalDetailsContent extends StatelessWidget {
  const _PersonalDetailsContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (BuildContext context, OnboardingState state) {
        if (state.isProfileLoading) {
          return OnboardingLoadingState(
            message: context.localization.homeLoading,
          );
        }

        if (state.profileLoadStatus == OnboardingLoadStatus.failure) {
          return OnboardingErrorState(
            failure: state.failure,
            onRetry: () {
              context.read<OnboardingBloc>().add(
                const OnboardingInitializedEvent(),
              );
            },
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const OnboardingProgressSection(
              step: 1,
              totalSteps: OnboardingConstants.totalSteps,
            ),
            const SizedBox(height: OnboardingConstants.sectionSpacing),
            OnboardingHeaderCopy(
              title: context.localization.onboardingPersonalHeadline,
              description: context.localization.onboardingPersonalDescription,
            ),
            const SizedBox(height: OnboardingConstants.sectionSpacing),
            PersonalDetailsProfilePhoto(
              onTap: () {
                context.read<OnboardingBloc>().add(
                  OnboardingFeedbackRequestedEvent(
                    message: context
                        .localization
                        .onboardingPhotoUploadPlaceholderMessage,
                  ),
                );
              },
            ),
            const SizedBox(height: OnboardingConstants.sectionSpacing),
            OnboardingTextField(
              label: context.localization.onboardingFullNameLabel,
              initialValue: state.fullName,
              hintText: context.localization.onboardingFullNameHint,
              errorText:
                  state.showPersonalValidationErrors &&
                      state.fullName.trim().isEmpty
                  ? context.localization.commonValidationFailure
                  : null,
              onChanged: (String value) {
                context.read<OnboardingBloc>().add(
                  OnboardingFullNameChangedEvent(fullName: value),
                );
              },
            ),
            const SizedBox(height: 16),
            PersonalDetailsDateField(
              label: context.localization.onboardingDateOfBirthLabel,
              value: state.formattedDateOfBirth,
              placeholder: context.localization.onboardingDateOfBirthHint,
              errorText:
                  state.showPersonalValidationErrors &&
                      state.dateOfBirth == null
                  ? context.localization.commonValidationFailure
                  : null,
              onTap: () {
                context.read<OnboardingBloc>().add(
                  const OnboardingDatePickerRequestedEvent(),
                );
              },
            ),
            const SizedBox(height: 16),
            PersonalDetailsGenderGroup(
              selectedGender: state.gender,
              errorText:
                  state.showPersonalValidationErrors && state.gender == null
                  ? context.localization.commonValidationFailure
                  : null,
              onGenderSelected: (String gender) {
                context.read<OnboardingBloc>().add(
                  OnboardingGenderChangedEvent(gender: gender),
                );
              },
            ),
            const SizedBox(height: 16),
            OnboardingReadOnlyField(
              label: context.localization.authMobileNumberLabel,
              value: state.phoneNumber,
              trailing: Chip(
                label: Text(context.localization.onboardingVerifiedLabel),
                side: BorderSide.none,
              ),
            ),
            const SizedBox(height: 16),
            OnboardingTextField(
              label: context.localization.onboardingAddressLabel,
              initialValue: state.address,
              hintText: context.localization.onboardingAddressHint,
              errorText:
                  state.showPersonalValidationErrors &&
                      state.address.trim().isEmpty
                  ? context.localization.commonValidationFailure
                  : null,
              maxLines: 3,
              onChanged: (String value) {
                context.read<OnboardingBloc>().add(
                  OnboardingAddressChangedEvent(address: value),
                );
              },
            ),
            const SizedBox(height: 16),
            OnboardingTextField(
              label: context.localization.onboardingReferralCodeLabel,
              initialValue: state.referralCode,
              hintText: context.localization.onboardingReferralCodeHint,
              onChanged: (String value) {
                context.read<OnboardingBloc>().add(
                  OnboardingReferralCodeChangedEvent(referralCode: value),
                );
              },
            ),
            const SizedBox(height: 16),
            OnboardingInfoBanner(
              message:
                  context.localization.onboardingPhotoUploadPlaceholderMessage,
            ),
          ],
        );
      },
    );
  }
}

Future<void> _selectDate(BuildContext context, DateTime? initialDate) async {
  context.read<OnboardingBloc>().add(const OnboardingDatePickerConsumedEvent());
  final DateTime now = DateTime.now();
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime(now.year - 25),
    firstDate: DateTime(1950),
    lastDate: DateTime(now.year - 18, now.month, now.day),
  );
  if (picked == null || !context.mounted) {
    return;
  }

  context.read<OnboardingBloc>().add(
    OnboardingDateOfBirthChangedEvent(dateOfBirth: picked),
  );
}
