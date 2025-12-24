import 'package:auto_pooling/presentation/auth/auth_screen.dart';
import 'package:auto_pooling/presentation/notifications/notifications_screen.dart';
import 'package:auto_pooling/presentation/payments/payments_screen.dart';
import 'package:auto_pooling/presentation/profile/profile_screen.dart';
import 'package:auto_pooling/presentation/ride_request/ride_request_screen.dart';
import 'package:auto_pooling/presentation/ride_tracking/ride_tracking_screen.dart';
import 'package:auto_route/auto_route.dart';

part 'routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => const [];
}
