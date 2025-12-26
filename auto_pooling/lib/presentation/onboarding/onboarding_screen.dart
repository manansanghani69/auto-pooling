import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes.dart';
import '../../shared_pref/pref_keys.dart';
import '../../shared_pref/prefs.dart';
import 'bloc/onboarding_bloc.dart';
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
  late final OnboardingBloc _onboardingBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _onboardingBloc = OnboardingBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _onboardingBloc.close();
    super.dispose();
  }

  void _handleContinue() {
    final int currentPage = _onboardingBloc.state.currentPage;
    if (currentPage < OnboardingConstants.totalPages - 1) {
      _pageController.nextPage(
        duration: OnboardingConstants.pageAnimationDuration,
        curve: Curves.easeOut,
      );
      return;
    }
    _completeOnboarding();
  }

  void _handleSkip() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await Prefs.setBool(PrefKeys.onboardingCompleted, true);
    if (!mounted) {
      return;
    }
    context.router.replace(const AuthRoute());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingBloc>.value(
      value: _onboardingBloc,
      child: Scaffold(
        body: OnboardingBody(
          pageController: _pageController,
          onContinue: _handleContinue,
          onSkip: _handleSkip,
        ),
      ),
    );
  }
}
