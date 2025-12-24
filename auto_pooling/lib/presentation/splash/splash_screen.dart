import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../auth/auth_screen.dart';
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
      Future.delayed(SplashConstants.navigationDelay, () {
        if (!mounted) {
          return;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => const AuthScreen(),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SplashBody(),
    );
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
              Expanded(
                child: Center(
                  child: const SplashContentContainer(),
                ),
              ),
              const SplashFooter(),
            ],
          ),
        ),
      ],
    );
  }
}
