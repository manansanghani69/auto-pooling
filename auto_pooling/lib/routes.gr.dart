// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'routes.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AuthOtpRoute.name: (routeData) {
      final args = routeData.argsAs<AuthOtpRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AuthOtpScreen(
          authBloc: args.authBloc,
          key: args.key,
        ),
      );
    },
    AuthRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    NotificationsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationsScreen(),
      );
    },
    OnboardingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingScreen(),
      );
    },
    PaymentsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PaymentsScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileRouteArgs>(
          orElse: () => const ProfileRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfileScreen(
          isEditing: args.isEditing,
          key: args.key,
        ),
      );
    },
    RideRequestRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RideRequestScreen(),
      );
    },
    RideTrackingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RideTrackingScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
  };
}

/// generated route for
/// [AuthOtpScreen]
class AuthOtpRoute extends PageRouteInfo<AuthOtpRouteArgs> {
  AuthOtpRoute({
    required AuthBloc authBloc,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          AuthOtpRoute.name,
          args: AuthOtpRouteArgs(
            authBloc: authBloc,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AuthOtpRoute';

  static const PageInfo<AuthOtpRouteArgs> page =
      PageInfo<AuthOtpRouteArgs>(name);
}

class AuthOtpRouteArgs {
  const AuthOtpRouteArgs({
    required this.authBloc,
    this.key,
  });

  final AuthBloc authBloc;

  final Key? key;

  @override
  String toString() {
    return 'AuthOtpRouteArgs{authBloc: $authBloc, key: $key}';
  }
}

/// generated route for
/// [AuthScreen]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
      : super(
          AuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationsScreen]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingScreen]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PaymentsScreen]
class PaymentsRoute extends PageRouteInfo<void> {
  const PaymentsRoute({List<PageRouteInfo>? children})
      : super(
          PaymentsRoute.name,
          initialChildren: children,
        );

  static const String name = 'PaymentsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    bool isEditing = false,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileRoute.name,
          args: ProfileRouteArgs(
            isEditing: isEditing,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<ProfileRouteArgs> page =
      PageInfo<ProfileRouteArgs>(name);
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.isEditing = false,
    this.key,
  });

  final bool isEditing;

  final Key? key;

  @override
  String toString() {
    return 'ProfileRouteArgs{isEditing: $isEditing, key: $key}';
  }
}

/// generated route for
/// [RideRequestScreen]
class RideRequestRoute extends PageRouteInfo<void> {
  const RideRequestRoute({List<PageRouteInfo>? children})
      : super(
          RideRequestRoute.name,
          initialChildren: children,
        );

  static const String name = 'RideRequestRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RideTrackingScreen]
class RideTrackingRoute extends PageRouteInfo<void> {
  const RideTrackingRoute({List<PageRouteInfo>? children})
      : super(
          RideTrackingRoute.name,
          initialChildren: children,
        );

  static const String name = 'RideTrackingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
