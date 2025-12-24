enum AppFlavor {
  dev,
  stage,
  prod,
}

class AppConfig {
  static AppFlavor appFlavor = AppFlavor.dev;

  static String get baseUrl {
    switch (appFlavor) {
      case AppFlavor.dev:
        return '';
      case AppFlavor.stage:
        return '';
      case AppFlavor.prod:
        return '';
    }
  }
}
