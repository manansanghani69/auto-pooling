import 'package:flutter/widgets.dart';

import 'core/services/injection_container.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
}
