import 'package:flutter/material.dart';

import 'common/theme/app_themes_data.dart';
import 'constants/app_constants.dart';
import 'core/services/injection_container.dart';
import 'shared_pref/prefs.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    Prefs.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppThemesData.lightTheme,
      routerConfig: _appRouter.config(),
    );
  }
}
