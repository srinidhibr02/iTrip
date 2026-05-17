import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:itrip/core/constants/app_constants.dart';
import 'package:itrip/core/constants/route_paths.dart';
import 'package:itrip/core/providers/onboarding_provider.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/providers/guest_mode_provider.dart';
import 'package:itrip/data/repositories/auth_repository.dart';

/// Splash screen with logo animation and navigation logic.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final onboardingDone = ref.read(onboardingCompleteProvider);
    final isLoggedIn = ref.read(authRepositoryProvider).isAuthenticated;
    final isGuest = ref.read(guestModeProvider);

    if (!onboardingDone) {
      context.go(RoutePaths.onboarding);
    } else if (isLoggedIn || isGuest) {
      context.go(RoutePaths.home);
    } else {
      context.go(RoutePaths.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/1.png',
                height: 120,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.map,
                  size: 80,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
              const SizedBox(height: 24),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 8),
              Text(
                AppConstants.appTagline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 1.2,
                    ),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 48),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
