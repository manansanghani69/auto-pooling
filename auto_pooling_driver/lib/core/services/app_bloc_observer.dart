import 'package:auto_pooling_driver/core/errors/error_reporter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  AppBlocObserver({required AppErrorReporter errorReporter})
      : _errorReporter = errorReporter;

  final AppErrorReporter _errorReporter;

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _errorReporter.recordError(error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
