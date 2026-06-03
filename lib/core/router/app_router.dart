import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:itrip/core/constants/route_paths.dart';
import 'package:itrip/core/providers/guest_mode_provider.dart';
import 'package:itrip/data/repositories/auth_repository.dart';
import 'package:itrip/features/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import 'package:itrip/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:itrip/features/auth/presentation/screens/login_screen.dart';
import 'package:itrip/features/auth/presentation/screens/register_screen.dart';
import 'package:itrip/features/budget/presentation/screens/budget_screen.dart';
import 'package:itrip/features/community/presentation/screens/community_screen.dart';
import 'package:itrip/features/emergency/presentation/screens/emergency_screen.dart';
import 'package:itrip/features/experience/presentation/screens/route_experience_screen.dart';
import 'package:itrip/features/gamification/presentation/screens/gamification_screen.dart';
import 'package:itrip/features/home/presentation/screens/home_screen.dart';
import 'package:itrip/features/home/presentation/screens/main_shell_screen.dart';
import 'package:itrip/features/map/presentation/screens/map_screen.dart';
import 'package:itrip/features/nearby/presentation/screens/nearby_screen.dart';
import 'package:itrip/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:itrip/features/packages/presentation/screens/packages_screen.dart';
import 'package:itrip/features/profile/presentation/screens/profile_screen.dart';
import 'package:itrip/features/routes/presentation/screens/routes_screen.dart';
import 'package:itrip/features/settings/presentation/screens/settings_screen.dart';
import 'package:itrip/features/splash/presentation/screens/splash_screen.dart';
import 'package:itrip/features/nearby/presentation/screens/place_detail_screen.dart';
import 'package:itrip/features/trip_planner/presentation/screens/create_trip_screen.dart';
import 'package:itrip/features/trip_planner/presentation/screens/trip_detail_screen.dart';
import 'package:itrip/features/trip_planner/presentation/screens/trip_planner_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isGuest = ref.read(guestModeProvider);
      final isAuthenticated = isLoggedIn || isGuest;
      final path = state.matchedLocation;
      final isAuthRoute = path == RoutePaths.login ||
          path == RoutePaths.register ||
          path == RoutePaths.forgotPassword;
      final isPublicRoute = path == RoutePaths.splash ||
          path == RoutePaths.onboarding ||
          isAuthRoute;

      if (path == RoutePaths.splash) return null;

      if (!isAuthenticated && !isPublicRoute) {
        return RoutePaths.login;
      }
      if (isAuthenticated && isAuthRoute) {
        return RoutePaths.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (_, __, child) => MainShellScreen(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.home,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: RoutePaths.tripPlanner,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const TripPlannerScreen(),
            ),
          ),
          GoRoute(
            path: RoutePaths.nearby,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const NearbyScreen(),
            ),
          ),
          GoRoute(
            path: RoutePaths.community,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const CommunityScreen(),
            ),
          ),
          GoRoute(
            path: RoutePaths.profile,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.createTrip,
        builder: (_, __) => const CreateTripScreen(),
      ),
      GoRoute(
        path: '/trip/:id',
        builder: (_, state) => TripDetailScreen(
          tripId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/place/:id',
        builder: (_, state) => PlaceDetailScreen(
          placeId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: RoutePaths.map,
        builder: (_, __) => const MapScreen(),
      ),
      GoRoute(
        path: RoutePaths.routes,
        builder: (_, __) => const RoutesScreen(),
      ),
      GoRoute(
        path: '${RoutePaths.routeExperience}/:id',
        builder: (_, state) => RouteExperienceScreen(
          routeId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: RoutePaths.budget,
        builder: (_, __) => const BudgetScreen(),
      ),
      GoRoute(
        path: RoutePaths.packages,
        builder: (_, __) => const PackagesScreen(),
      ),
      GoRoute(
        path: RoutePaths.aiAssistant,
        builder: (_, __) => const AiAssistantScreen(),
      ),
      GoRoute(
        path: RoutePaths.settings,
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.emergency,
        builder: (_, __) => const EmergencyScreen(),
      ),
      GoRoute(
        path: RoutePaths.gamification,
        builder: (_, __) => const GamificationScreen(),
      ),
    ],
  );
});
