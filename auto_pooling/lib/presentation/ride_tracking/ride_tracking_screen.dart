import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'constants/ride_tracking_constants.dart';
import 'widgets/ride_tracking_placeholder_widgets.dart';

@RoutePage()
class RideTrackingScreen extends StatelessWidget {
  const RideTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RideTrackingBody(),
    );
  }
}

class RideTrackingBody extends StatelessWidget {
  const RideTrackingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: RideTrackingConstants.horizontalPadding,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: RideTrackingConstants.sectionSpacing),
            RideTrackingTitleText(),
            SizedBox(height: RideTrackingConstants.titleSpacing),
            RideTrackingSubtitleText(),
            SizedBox(height: RideTrackingConstants.sectionSpacing),
            RideTrackingPrimaryActionButton(),
          ],
        ),
      ),
    );
  }
}
