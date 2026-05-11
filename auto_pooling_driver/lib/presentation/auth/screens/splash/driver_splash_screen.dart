import 'package:auto_pooling_driver/core/services/injection_container.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_gate_bloc.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_gate_event.dart';
import 'package:auto_pooling_driver/presentation/auth/screens/splash/widgets/driver_splash_body.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DriverSplashScreen extends StatelessWidget {
  const DriverSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthGateBloc>(
      create: (_) => sl<AuthGateBloc>()..add(const AuthGateStartedEvent()),
      child: const DriverSplashBody(),
    );
  }
}
