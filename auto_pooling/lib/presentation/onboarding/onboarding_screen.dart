import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../shared_pref/pref_keys.dart';
import '../../shared_pref/prefs.dart';
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
  int _currentPage = 0;

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

  void _handlePageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _handleContinue() {
    if (_currentPage < OnboardingConstants.totalPages - 1) {
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
    return Scaffold(
      body: OnboardingBody(
        pageController: _pageController,
        currentPage: _currentPage,
        onPageChanged: _handlePageChanged,
        onContinue: _handleContinue,
        onSkip: _handleSkip,
      ),
    );
  }
}
