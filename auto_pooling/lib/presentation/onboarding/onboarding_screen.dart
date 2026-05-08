import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/injection_container.dart';
import '../../routes.dart';
import '../../utils/route_resolver.dart';
import '../../widgets/app_snack_bar_message.dart';
import '../../widgets/styling/app_colors.dart';
import 'bloc/onboarding_bloc.dart';
import 'bloc/onboarding_state.dart';
import 'constants/onboarding_constants.dart';
import 'widgets/onboarding_widgets.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingBloc>(
      create: (_) => sl<OnboardingBloc>(),
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.requestedPage != current.requestedPage ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.status == OnboardingStatus.pageAdvanceRequested &&
              state.requestedPage != null) {
            _pageController.animateToPage(
              state.requestedPage!,
              duration: OnboardingConstants.pageAnimationDuration,
              curve: Curves.easeOut,
            );
            return;
          }
          if (state.status == OnboardingStatus.completed) {
            RouteResolver.resolveNextRoute().then((route) {
              if (context.mounted) {
                context.router.replaceAll([route]);
              }
            });
            return;
          }
          if (state.status == OnboardingStatus.failure &&
              state.errorMessage.isNotEmpty) {
            _showOnboardingSnackBar(context, state.errorMessage);
          }
        },
        child: Scaffold(body: OnboardingBody(pageController: _pageController)),
      ),
    );
  }
}

void _showOnboardingSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AppSnackBarMessage(message: message),
      backgroundColor: context.currentTheme.error,
    ),
  );
}
