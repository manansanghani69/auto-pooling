import 'package:auto_pooling_driver/presentation/home/home_screen.dart';
import 'package:auto_route/auto_route.dart';

part 'routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(page: HomeRoute.page, initial: true),
  ];
}
