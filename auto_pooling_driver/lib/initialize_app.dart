import 'dart:ui';

import 'package:auto_pooling_driver/core/errors/error_reporter.dart';
import 'package:auto_pooling_driver/core/services/app_bloc_observer.dart';
import 'package:auto_pooling_driver/core/services/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  FlutterError.onError = sl<AppErrorReporter>().recordFlutterError;
  PlatformDispatcher.instance.onError = (
    Object error,
    StackTrace stackTrace,
  ) {
    sl<AppErrorReporter>().recordError(error, stackTrace);
    return true;
  };
  Bloc.observer = sl<AppBlocObserver>();
}
