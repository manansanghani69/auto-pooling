import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:auto_pooling_driver/core/services/injection_container.dart';
import 'package:auto_pooling_driver/l10n/app_localizations.dart';
import 'package:auto_pooling_driver/routes.dart';
import 'package:auto_pooling_driver/services/theme_service.dart';
import 'package:flutter/material.dart';

class AutoPoolingDriverApp extends StatelessWidget {
  const AutoPoolingDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => context.localization.appTitle,
      theme: sl<ThemeService>().lightTheme,
      routerConfig: sl<AppRouter>().config(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
