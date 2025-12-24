import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../shared_pref/pref_keys.dart';
import '../../shared_pref/prefs.dart';
import 'constants/splash_constants.dart';
import 'widgets/splash_widgets.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateFromSplash();
    });
  }

  Future<void> _navigateFromSplash() async {
    await Future.delayed(SplashConstants.navigationDelay);
    if (!mounted) {
      return;
    }
    final bool hasCompletedOnboarding =
        await Prefs.getBool(PrefKeys.onboardingCompleted) ?? false;
    if (!mounted) {
      return;
    }
    final PageRouteInfo<void> nextRoute = hasCompletedOnboarding
        ? const AuthRoute()
        : const OnboardingRoute();
    context.router.replace(nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const SplashBody());
  }
}

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SplashBackground(),
        SafeArea(
          child: Column(
            children: [
              Expanded(child: Center(child: const SplashContentContainer())),
              const SplashFooter(),
            ],
          ),
        ),
      ],
    );
  }
}
