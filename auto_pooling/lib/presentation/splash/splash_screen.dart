import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/injection_container.dart';
import '../../routes.dart';
import 'bloc/splash_bloc.dart';
import 'bloc/splash_event.dart';
import 'bloc/splash_state.dart';
import 'widgets/splash_widgets.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (_) => sl<SplashBloc>()..add(const SplashStartedEvent()),
      child: BlocListener<SplashBloc, SplashState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.destination != current.destination,
        listener: (context, state) {
          if (state.status != SplashStatus.resolved) {
            return;
          }
          final PageRouteInfo<dynamic> route = _routeForDestination(
            state.destination,
          );
          context.router.replace(route);
        },
        child: const Scaffold(body: SplashBody()),
      ),
    );
  }

  PageRouteInfo<dynamic> _routeForDestination(SplashDestination? destination) {
    switch (destination) {
      case SplashDestination.onboarding:
        return const OnboardingRoute();
      case SplashDestination.auth:
        return const AuthRoute();
      case SplashDestination.profile:
        return ProfileRoute();
      case SplashDestination.home:
        return const HomeRoute();
      case null:
        return const AuthRoute();
    }
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
