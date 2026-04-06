import 'dart:async';

import 'package:auto_pooling_driver/app.dart';
import 'package:auto_pooling_driver/core/errors/error_reporter.dart';
import 'package:auto_pooling_driver/core/services/injection_container.dart';
import 'package:auto_pooling_driver/initialize_app.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      await initializeApp();
      runApp(const AutoPoolingDriverApp());
    },
    (Object error, StackTrace stackTrace) {
      if (sl.isRegistered<AppErrorReporter>()) {
        sl<AppErrorReporter>().recordError(error, stackTrace);
        return;
      }

      debugPrint('Unhandled bootstrap error: $error');
      debugPrintStack(stackTrace: stackTrace);
    },
  );
}
