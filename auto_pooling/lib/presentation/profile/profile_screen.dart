import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/injection_container.dart';
import '../../routes.dart';
import '../../widgets/app_snack_bar_message.dart';
import '../../widgets/styling/app_colors.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';
import 'widgets/profile_placeholder_widgets.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  final bool isEditing;

  const ProfileScreen({this.isEditing = false, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) =>
          ProfileBloc(profileUseCase: sl())
            ..add(ProfileStartedEvent(isEditing: isEditing)),
      child: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.status == ProfileStatus.saved) {
            context.router.replaceAll([const HomeRoute()]);
            return;
          }
          if (state.errorMessage.isNotEmpty) {
            _showProfileSnackBar(context, state.errorMessage);
          }
        },
        child: const ProfileScreenScaffold(),
      ),
    );
  }
}

void _showProfileSnackBar(BuildContext context, String message) {
  if (message.isEmpty) {
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AppSnackBarMessage(message: message),
      backgroundColor: context.currentTheme.error,
    ),
  );
}

class ProfileScreenScaffold extends StatelessWidget {
  const ProfileScreenScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Form(
      child: Scaffold(
        appBar: ProfileAppBar(),
        body: ProfileBody(),
        bottomNavigationBar: ProfileBottomBar(),
      ),
    );
  }
}
