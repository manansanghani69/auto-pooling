import 'package:auto_route/auto_route.dart';
import '../routes.dart';
import '../shared_pref/pref_keys.dart';
import '../shared_pref/prefs.dart';

class RouteResolver {
  static Future<PageRouteInfo<dynamic>> resolveNextRoute() async {
    final bool hasCompletedOnboarding =
        await Prefs.getBool(PrefKeys.onboardingCompleted) ?? false;
    final String authToken = await Prefs.getString(PrefKeys.authToken) ?? '';
    final bool hasCompletedProfile = await _hasCompletedProfileDetails();

    if (!hasCompletedOnboarding) {
      return const OnboardingRoute();
    }
    if (authToken.trim().isEmpty) {
      return const AuthRoute();
    }
    if (!hasCompletedProfile) {
      return ProfileRoute();
    }
    return const HomeRoute();
  }

  static Future<bool> _hasCompletedProfileDetails() async {
    final bool hasProfileFlag =
        await Prefs.getBool(PrefKeys.profileCompleted) ?? false;
    if (hasProfileFlag) {
      return true;
    }

    final String profileName =
        await Prefs.getString(PrefKeys.profileName) ?? '';
    return profileName.trim().isNotEmpty;
  }
}
