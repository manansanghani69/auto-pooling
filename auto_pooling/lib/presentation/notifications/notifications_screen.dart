import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'constants/notifications_constants.dart';
import 'widgets/notifications_placeholder_widgets.dart';

@RoutePage()
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NotificationsBody(),
    );
  }
}

class NotificationsBody extends StatelessWidget {
  const NotificationsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: NotificationsConstants.horizontalPadding,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: NotificationsConstants.sectionSpacing),
            NotificationsTitleText(),
            SizedBox(height: NotificationsConstants.titleSpacing),
            NotificationsSubtitleText(),
            SizedBox(height: NotificationsConstants.sectionSpacing),
            NotificationsPrimaryActionButton(),
          ],
        ),
      ),
    );
  }
}
