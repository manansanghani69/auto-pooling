import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/presentation/onboarding/widgets/onboarding_vehicle_type_card.dart';
import 'package:flutter/material.dart';

class VehicleDetailsTypeGrid extends StatelessWidget {
  const VehicleDetailsTypeGrid({
    required this.selectedVehicleType,
    required this.onVehicleTypeSelected,
    super.key,
  });

  final String selectedVehicleType;
  final ValueChanged<String> onVehicleTypeSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: <Widget>[
        OnboardingVehicleTypeCard(
          label: context.localization.onboardingVehicleTypeHatchback,
          icon: Icons.directions_car_filled_rounded,
          isSelected:
              selectedVehicleType ==
              context.localization.onboardingVehicleTypeHatchback,
          onTap: () => onVehicleTypeSelected(
            context.localization.onboardingVehicleTypeHatchback,
          ),
        ),
        OnboardingVehicleTypeCard(
          label: context.localization.onboardingVehicleTypeSedan,
          icon: Icons.airport_shuttle_rounded,
          isSelected:
              selectedVehicleType ==
              context.localization.onboardingVehicleTypeSedan,
          onTap: () => onVehicleTypeSelected(
            context.localization.onboardingVehicleTypeSedan,
          ),
        ),
        OnboardingVehicleTypeCard(
          label: context.localization.onboardingVehicleTypeSuv,
          icon: Icons.local_taxi_rounded,
          isSelected:
              selectedVehicleType ==
              context.localization.onboardingVehicleTypeSuv,
          onTap: () => onVehicleTypeSelected(
            context.localization.onboardingVehicleTypeSuv,
          ),
        ),
        OnboardingVehicleTypeCard(
          label: context.localization.onboardingVehicleTypeBike,
          icon: Icons.two_wheeler_rounded,
          isSelected:
              selectedVehicleType ==
              context.localization.onboardingVehicleTypeBike,
          onTap: () => onVehicleTypeSelected(
            context.localization.onboardingVehicleTypeBike,
          ),
        ),
      ],
    );
  }
}
