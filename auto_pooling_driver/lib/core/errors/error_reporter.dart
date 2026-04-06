import 'package:flutter/foundation.dart';

abstract class AppErrorReporter {
  void recordError(Object error, StackTrace stackTrace);

  void recordFlutterError(FlutterErrorDetails details);
}

class DebugAppErrorReporter implements AppErrorReporter {
  @override
  void recordError(Object error, StackTrace stackTrace) {
    debugPrint('Unhandled error: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  @override
  void recordFlutterError(FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  }
}
