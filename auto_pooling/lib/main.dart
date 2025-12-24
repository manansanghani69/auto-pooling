import 'package:flutter/material.dart';

import 'common/theme/app_themes_data.dart';
import 'constants/app_constants.dart';
import 'core/services/injection_container.dart';
import 'presentation/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppThemesData.lightTheme,
      home: const SplashScreen(),
    );
  }
}
