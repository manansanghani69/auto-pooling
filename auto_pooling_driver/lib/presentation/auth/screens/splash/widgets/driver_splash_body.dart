import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/constants/app_constants.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/gen/assets.gen.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_gate_bloc.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_gate_state.dart';
import 'package:auto_pooling_driver/routes.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverSplashBody extends StatelessWidget {
  const DriverSplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthGateBloc, AuthGateState>(
      listenWhen: (AuthGateState previous, AuthGateState current) =>
          previous.routeTarget != current.routeTarget &&
          current.status == AuthGateStatus.resolved,
      listener: (BuildContext context, AuthGateState state) {
        final AuthGateRouteTarget? routeTarget = state.routeTarget;
        if (routeTarget == null) {
          return;
        }

        context.router.replaceAll(<PageRouteInfo<dynamic>>[
          _routeForTarget(routeTarget),
        ]);
      },
      child: Scaffold(
        backgroundColor: context.currentTheme.backgroundPrimary,
        body: const SafeArea(child: DriverSplashContent()),
      ),
    );
  }

  PageRouteInfo<dynamic> _routeForTarget(AuthGateRouteTarget target) {
    switch (target) {
      case AuthGateRouteTarget.login:
        return const DriverLoginRoute();
      case AuthGateRouteTarget.personalDetails:
        return const DriverOnboardingPersonalDetailsRoute();
      case AuthGateRouteTarget.documentUpload:
        return const DriverOnboardingDocumentUploadRoute();
      case AuthGateRouteTarget.applicationStatus:
        return const DriverOnboardingStatusRoute();
      case AuthGateRouteTarget.home:
        return const HomeRoute();
    }
  }
}

class DriverSplashContent extends StatelessWidget {
  const DriverSplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            DriverSplashLogo(),
            SizedBox(height: 24),
            DriverSplashTitle(),
            SizedBox(height: 20),
            DriverSplashLoader(),
          ],
        ),
      ),
    );
  }
}

class DriverSplashLogo extends StatelessWidget {
  const DriverSplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Assets.icons.appMark.svg(width: 64, height: 64);
  }
}

class DriverSplashTitle extends StatelessWidget {
  const DriverSplashTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.appTitle,
      textAlign: TextAlign.center,
      style: AppTextStyles.h1Bold.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class DriverSplashLoader extends StatelessWidget {
  const DriverSplashLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}
