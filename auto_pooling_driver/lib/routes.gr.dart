// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'routes.dart';

/// generated route for
/// [DriverLoginScreen]
class DriverLoginRoute extends PageRouteInfo<void> {
  const DriverLoginRoute({List<PageRouteInfo>? children})
    : super(DriverLoginRoute.name, initialChildren: children);

  static const String name = 'DriverLoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverLoginScreen();
    },
  );
}

/// generated route for
/// [DriverOnboardingDocumentUploadScreen]
class DriverOnboardingDocumentUploadRoute extends PageRouteInfo<void> {
  const DriverOnboardingDocumentUploadRoute({List<PageRouteInfo>? children})
    : super(
        DriverOnboardingDocumentUploadRoute.name,
        initialChildren: children,
      );

  static const String name = 'DriverOnboardingDocumentUploadRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverOnboardingDocumentUploadScreen();
    },
  );
}

/// generated route for
/// [DriverOnboardingPersonalDetailsScreen]
class DriverOnboardingPersonalDetailsRoute extends PageRouteInfo<void> {
  const DriverOnboardingPersonalDetailsRoute({List<PageRouteInfo>? children})
    : super(
        DriverOnboardingPersonalDetailsRoute.name,
        initialChildren: children,
      );

  static const String name = 'DriverOnboardingPersonalDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverOnboardingPersonalDetailsScreen();
    },
  );
}

/// generated route for
/// [DriverOnboardingStatusScreen]
class DriverOnboardingStatusRoute extends PageRouteInfo<void> {
  const DriverOnboardingStatusRoute({List<PageRouteInfo>? children})
    : super(DriverOnboardingStatusRoute.name, initialChildren: children);

  static const String name = 'DriverOnboardingStatusRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverOnboardingStatusScreen();
    },
  );
}

/// generated route for
/// [DriverOnboardingVehicleDetailsScreen]
class DriverOnboardingVehicleDetailsRoute
    extends PageRouteInfo<DriverOnboardingVehicleDetailsRouteArgs> {
  DriverOnboardingVehicleDetailsRoute({
    required OnboardingBloc onboardingBloc,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         DriverOnboardingVehicleDetailsRoute.name,
         args: DriverOnboardingVehicleDetailsRouteArgs(
           onboardingBloc: onboardingBloc,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'DriverOnboardingVehicleDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DriverOnboardingVehicleDetailsRouteArgs>();
      return DriverOnboardingVehicleDetailsScreen(
        onboardingBloc: args.onboardingBloc,
        key: args.key,
      );
    },
  );
}

class DriverOnboardingVehicleDetailsRouteArgs {
  const DriverOnboardingVehicleDetailsRouteArgs({
    required this.onboardingBloc,
    this.key,
  });

  final OnboardingBloc onboardingBloc;

  final Key? key;

  @override
  String toString() {
    return 'DriverOnboardingVehicleDetailsRouteArgs{onboardingBloc: $onboardingBloc, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DriverOnboardingVehicleDetailsRouteArgs) return false;
    return onboardingBloc == other.onboardingBloc && key == other.key;
  }

  @override
  int get hashCode => onboardingBloc.hashCode ^ key.hashCode;
}

/// generated route for
/// [DriverOtpScreen]
class DriverOtpRoute extends PageRouteInfo<DriverOtpRouteArgs> {
  DriverOtpRoute({
    required AuthBloc authBloc,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         DriverOtpRoute.name,
         args: DriverOtpRouteArgs(authBloc: authBloc, key: key),
         initialChildren: children,
       );

  static const String name = 'DriverOtpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DriverOtpRouteArgs>();
      return DriverOtpScreen(authBloc: args.authBloc, key: args.key);
    },
  );
}

class DriverOtpRouteArgs {
  const DriverOtpRouteArgs({required this.authBloc, this.key});

  final AuthBloc authBloc;

  final Key? key;

  @override
  String toString() {
    return 'DriverOtpRouteArgs{authBloc: $authBloc, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DriverOtpRouteArgs) return false;
    return authBloc == other.authBloc && key == other.key;
  }

  @override
  int get hashCode => authBloc.hashCode ^ key.hashCode;
}

/// generated route for
/// [DriverSplashScreen]
class DriverSplashRoute extends PageRouteInfo<void> {
  const DriverSplashRoute({List<PageRouteInfo>? children})
    : super(DriverSplashRoute.name, initialChildren: children);

  static const String name = 'DriverSplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverSplashScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}
