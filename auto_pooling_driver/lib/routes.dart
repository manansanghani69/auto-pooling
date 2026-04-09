import 'package:auto_pooling_driver/presentation/auth/bloc/auth_bloc.dart';
import 'package:auto_pooling_driver/presentation/auth/screens/driver_login/driver_login_screen.dart';
import 'package:auto_pooling_driver/presentation/auth/screens/otp/driver_otp_screen.dart';
import 'package:auto_pooling_driver/presentation/home/home_screen.dart';
import 'package:auto_pooling_driver/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:auto_pooling_driver/presentation/onboarding/screens/application_status/application_status_screen.dart';
import 'package:auto_pooling_driver/presentation/onboarding/screens/document_upload/document_upload_screen.dart';
import 'package:auto_pooling_driver/presentation/onboarding/screens/personal_details/personal_details_screen.dart';
import 'package:auto_pooling_driver/presentation/onboarding/screens/vehicle_details/vehicle_details_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

part 'routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(page: DriverLoginRoute.page, initial: true),
    AutoRoute(page: DriverOtpRoute.page),
    AutoRoute(page: DriverOnboardingPersonalDetailsRoute.page),
    AutoRoute(page: DriverOnboardingVehicleDetailsRoute.page),
    AutoRoute(page: DriverOnboardingDocumentUploadRoute.page),
    AutoRoute(page: DriverOnboardingStatusRoute.page),
    AutoRoute(page: HomeRoute.page),
  ];
}
