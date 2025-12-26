import 'package:flutter/material.dart';

import 'common/theme/app_themes_data.dart';
import 'constants/app_constants.dart';
import 'initialize_app.dart';
import 'routes.dart';

Future<void> main() async {
  await initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppThemesData.lightTheme,
      routerConfig: _appRouter.config(),
    );
  }
}
