import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:rider/core/services/app_preferences.dart';
import 'package:rider/core/services/auth_service.dart';
import 'package:rider/screens/active_trip_screen.dart';
import 'package:rider/screens/cargo_screen.dart';
import 'package:rider/screens/cold_chain_cargo_screen.dart';
import 'package:rider/screens/admin_dashboard_screen.dart';
import 'package:rider/screens/destination_search_screen.dart';
import 'package:rider/screens/home_dashboard_screen.dart';
import 'package:rider/screens/login_screen.dart';
import 'package:rider/screens/onboarding_screen.dart';
import 'package:rider/screens/freight_screen.dart';
import 'package:rider/screens/profile_screen.dart';
import 'package:rider/screens/payment_methods_screen.dart';
import 'package:rider/screens/reports_screen.dart';
import 'package:rider/screens/saved_places_screen.dart';
import 'package:rider/screens/register_screen.dart';
import 'package:rider/screens/security_privacy_screen.dart';
import 'package:rider/screens/support_center_screen.dart';
import 'package:rider/screens/trip_history_screen.dart';
import 'package:rider/screens/language_screen.dart';
import 'package:rider/screens/route_recommendation_screen.dart';
import 'package:rider/screens/route_color_screen.dart';
import 'package:rider/screens/ride_hailing_screen.dart';
import 'package:rider/screens/splash_screen.dart';
import 'package:rider/screens/bus_pool_screen.dart';
import 'package:rider/screens/transit_copilot_screen.dart';
import 'package:rider/screens/wallet_screen.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const rideHailing = '/ride';
  static const busPool = '/bus-pool';
  static const activeTrip = '/active-trip';
  static const cargo = '/cargo';
  static const freight = '/cargo/freight';
  static const coldChain = '/cargo/cold-chain';
  static const wallet = '/wallet';
  static const profile = '/profile';
  static const tripHistory = '/profile/trip-history';
  static const paymentMethods = '/profile/payment-methods';
  static const securityPrivacy = '/profile/security-privacy';
  static const supportCenter = '/profile/support-center';
  static const language = '/profile/language';
  static const reports = '/reports';
  static const savedPlaces = '/saved-places';
  static const admin = '/admin';
  static const destinationSearch = '/destination-search';
  static const routeRecommendation = '/route-recommendation';
  static const routeColor = '/route-color';
  static const copilot = '/copilot';
}

GoRouter createRouter({
  required AppPreferences prefs,
  required AuthService auth,
}) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: Listenable.merge([prefs, auth]),
    redirect: (context, state) {
      final path = state.matchedLocation;

      if (!prefs.initialized && path != AppRoutes.splash) {
        return AppRoutes.splash;
      }

      if (path == AppRoutes.splash && prefs.initialized) {
        if (!prefs.onboardingComplete) return AppRoutes.onboarding;
        return auth.isAuthenticated ? AppRoutes.home : AppRoutes.login;
      }

      final authPages = {AppRoutes.login, AppRoutes.register, AppRoutes.onboarding};
      if (prefs.onboardingComplete && !auth.isAuthenticated && !authPages.contains(path)) {
        return AppRoutes.login;
      }
      if (auth.isAuthenticated && authPages.contains(path)) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.onboarding, builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (_, _) => const RegisterScreen()),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeDashboardScreen()),
      GoRoute(path: AppRoutes.rideHailing, builder: (_, _) => const RideHailingScreen()),
      GoRoute(path: AppRoutes.busPool, builder: (_, _) => const BusPoolScreen()),
      GoRoute(path: AppRoutes.activeTrip, builder: (_, _) => const ActiveTripScreen()),
      GoRoute(path: AppRoutes.cargo, builder: (_, _) => const CargoScreen()),
      GoRoute(path: AppRoutes.freight, builder: (_, _) => const FreightScreen()),
      GoRoute(path: AppRoutes.coldChain, builder: (_, _) => const ColdChainCargoScreen()),
      GoRoute(path: AppRoutes.wallet, builder: (_, _) => const WalletScreen()),
      GoRoute(path: AppRoutes.profile, builder: (_, _) => const ProfileScreen()),
      GoRoute(path: AppRoutes.tripHistory, builder: (_, _) => const TripHistoryScreen()),
      GoRoute(path: AppRoutes.paymentMethods, builder: (_, _) => const PaymentMethodsScreen()),
      GoRoute(path: AppRoutes.securityPrivacy, builder: (_, _) => const SecurityPrivacyScreen()),
      GoRoute(path: AppRoutes.supportCenter, builder: (_, _) => const SupportCenterScreen()),
      GoRoute(path: AppRoutes.language, builder: (_, _) => const LanguageScreen()),
      GoRoute(path: AppRoutes.reports, builder: (_, _) => const ReportsScreen()),
      GoRoute(path: AppRoutes.savedPlaces, builder: (_, _) => const SavedPlacesScreen()),
      GoRoute(path: AppRoutes.admin, builder: (_, _) => const AdminDashboardScreen()),
      GoRoute(
        path: AppRoutes.destinationSearch,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? const {};
          return DestinationSearchScreen(
            returnSelection: extra['returnSelection'] as bool? ?? false,
            origin: extra['origin'] as String? ?? 'Kituo cha Ubungo',
          );
        },
      ),
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
