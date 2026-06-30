import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rider/core/services/app_preferences.dart';
import 'package:rider/screens/active_trip_screen.dart';
import 'package:rider/screens/cargo_screen.dart';
import 'package:rider/screens/admin_dashboard_screen.dart';
import 'package:rider/screens/destination_search_screen.dart';
import 'package:rider/screens/home_dashboard_screen.dart';
import 'package:rider/screens/onboarding_screen.dart';
import 'package:rider/screens/profile_screen.dart';
import 'package:rider/screens/reports_screen.dart';
import 'package:rider/screens/saved_places_screen.dart';
import 'package:rider/screens/route_recommendation_screen.dart';
import 'package:rider/screens/route_color_screen.dart';
import 'package:rider/screens/ride_hailing_screen.dart';
import 'package:rider/screens/splash_screen.dart';
import 'package:rider/screens/transit_copilot_screen.dart';
import 'package:rider/screens/wallet_screen.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const rideHailing = '/ride';
  static const activeTrip = '/active-trip';
  static const cargo = '/cargo';
  static const wallet = '/wallet';
  static const profile = '/profile';
  static const reports = '/reports';
  static const savedPlaces = '/saved-places';
  static const admin = '/admin';
  static const destinationSearch = '/destination-search';
  static const routeRecommendation = '/route-recommendation';
  static const routeColor = '/route-color';
  static const copilot = '/copilot';
}

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final prefs = context.read<AppPreferences>();
      final path = state.matchedLocation;

      if (!prefs.initialized && path != AppRoutes.splash) {
        return AppRoutes.splash;
      }

      if (path == AppRoutes.splash && prefs.initialized) {
        return prefs.onboardingComplete ? AppRoutes.home : AppRoutes.onboarding;
      }

      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.onboarding, builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeDashboardScreen()),
      GoRoute(path: AppRoutes.rideHailing, builder: (_, _) => const RideHailingScreen()),
      GoRoute(path: AppRoutes.activeTrip, builder: (_, _) => const ActiveTripScreen()),
      GoRoute(path: AppRoutes.cargo, builder: (_, _) => const CargoScreen()),
      GoRoute(path: AppRoutes.wallet, builder: (_, _) => const WalletScreen()),
      GoRoute(path: AppRoutes.profile, builder: (_, _) => const ProfileScreen()),
      GoRoute(path: AppRoutes.reports, builder: (_, _) => const ReportsScreen()),
      GoRoute(path: AppRoutes.savedPlaces, builder: (_, _) => const SavedPlacesScreen()),
      GoRoute(path: AppRoutes.admin, builder: (_, _) => const AdminDashboardScreen()),
      GoRoute(path: AppRoutes.destinationSearch, builder: (_, _) => const DestinationSearchScreen()),
      GoRoute(
        path: AppRoutes.routeRecommendation,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? const {};
          return RouteRecommendationScreen(
            origin: extra['origin'] as String? ?? 'Kituo cha Ubungo',
            destination: extra['destination'] as String? ?? 'Posta Mpya',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.routeColor,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? const {};
          return RouteColorScreen(
            routeColor: extra['routeColor'] as String? ?? 'Blue',
            destination: extra['destination'] as String? ?? 'Posta Mpya',
            routeId: extra['routeId'] as String? ?? 'default-route',
          );
        },
      ),
      GoRoute(path: AppRoutes.copilot, builder: (_, _) => const TransitCopilotScreen()),
    ],
  );
}
