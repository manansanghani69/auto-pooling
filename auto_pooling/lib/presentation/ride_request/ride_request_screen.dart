import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'constants/ride_request_constants.dart';
import 'widgets/ride_request_placeholder_widgets.dart';

@RoutePage()
class RideRequestScreen extends StatelessWidget {
  const RideRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RideRequestBody(),
    );
  }
}

class RideRequestBody extends StatelessWidget {
  const RideRequestBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: RideRequestConstants.horizontalPadding,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: RideRequestConstants.sectionSpacing),
            RideRequestTitleText(),
            SizedBox(height: RideRequestConstants.titleSpacing),
            RideRequestSubtitleText(),
            SizedBox(height: RideRequestConstants.sectionSpacing),
            RideRequestPrimaryActionButton(),
          ],
        ),
      ),
    );
  }
}
