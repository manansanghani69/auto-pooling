import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'constants/profile_constants.dart';
import 'widgets/profile_placeholder_widgets.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProfileBody(),
    );
  }
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: ProfileConstants.horizontalPadding,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ProfileConstants.sectionSpacing),
            ProfileTitleText(),
            SizedBox(height: ProfileConstants.titleSpacing),
            ProfileSubtitleText(),
            SizedBox(height: ProfileConstants.sectionSpacing),
            ProfilePrimaryActionButton(),
          ],
        ),
      ),
    );
  }
}
