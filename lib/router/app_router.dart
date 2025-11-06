import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../features/auth/presentation/sign_in_page.dart';
import '../features/auth/presentation/sign_up_page.dart';
import '../features/task/presentation/dashboard_page.dart';
import '../features/task/presentation/biometric_guard.dart';
import '../features/auth/data/auth_repository.dart'; // Import AuthRepository

/// Builds the GoRouter instance for the application.
GoRouter buildRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
      GoRoute(path: '/sign-in', builder: (_, __) => const SignInPage()),
      GoRoute(path: '/sign-up', builder: (_, __) => const SignUpPage()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) =>
            const BiometricGuard(child: DashboardPage()),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = AuthRepository.instance.isSignedIn;
      final goingToSignIn = state.matchedLocation == '/sign-in';
      final goingToSignUp = state.matchedLocation == '/sign-up';
      final goingToSplash = state.matchedLocation == '/splash';
      final goingToOnboarding = state.matchedLocation == '/onboarding';

      // If not logged in, and not going to sign-in, sign-up, splash or onboarding, redirect to sign-in
      if (!isLoggedIn &&
          !goingToSignIn &&
          !goingToSignUp &&
          !goingToSplash &&
          !goingToOnboarding) {
        return '/sign-in';
      }

      // If logged in and going to sign-in, sign-up, splash or onboarding, redirect to dashboard
      if (isLoggedIn &&
          (goingToSignIn || goingToSignUp || goingToSplash || goingToOnboarding)) {
        return '/dashboard';
      }

      // No redirect
      return null;
    },
  );
}
