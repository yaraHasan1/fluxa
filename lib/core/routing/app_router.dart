import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/forget_password/presentation/screens/forget_password_screen.dart';
import '../../features/authentication/forget_password/presentation/screens/reset_password_screen.dart';
import '../../features/authentication/login/presentation/screens/login_screen.dart';
import '../../features/authentication/signup/presentation/screens/signup_screen.dart';
import '../../features/authentication/verification/presentation/screens/verification_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/organisations/presentation/screens/add_organisation_screen.dart';
import '../../features/organisations/presentation/screens/organisation_settings_screen.dart';
import '../../features/organisations/presentation/screens/organisations_list_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/change_password_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

/// The application router.
///
/// Routes are declared flat for now. Once the Figma flow confirms whether the
/// main sections sit behind a persistent bottom bar, the home/dashboard/history/
/// profile branch moves into a `StatefulShellRoute.indexedStack` so each tab
/// keeps its own navigation stack.
///
/// No `redirect` guard is wired yet — it is added when the authentication
/// feature has a real session source to read from.
abstract final class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splashPath,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splash,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingPath,
        name: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),

      // --- Authentication ---------------------------------------------
      GoRoute(
        path: AppRoutes.authPath,
        name: AppRoutes.auth,
        redirect: (_, _) => AppRoutes.loginPath,
        routes: <RouteBase>[
          GoRoute(
            path: 'login',
            name: AppRoutes.login,
            builder: (_, _) => const LoginScreen(),
          ),
          GoRoute(
            path: 'signup',
            name: AppRoutes.signup,
            builder: (_, _) => const SignupScreen(),
          ),
          GoRoute(
            path: 'verification',
            name: AppRoutes.verification,
            builder: (_, _) => const VerificationScreen(),
          ),
          GoRoute(
            path: 'forget-password',
            name: AppRoutes.forgetPassword,
            builder: (_, _) => const ForgetPasswordScreen(),
            routes: <RouteBase>[
              // The OTP step in between reuses [VerificationScreen]; only the
              // final "enter new password" frame is its own destination.
              GoRoute(
                path: 'reset',
                name: AppRoutes.resetPassword,
                builder: (_, _) => const ResetPasswordScreen(),
              ),
            ],
          ),
        ],
      ),

      // --- Main sections ----------------------------------------------
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.home,
        builder: (_, _) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboardPath,
        name: AppRoutes.dashboard,
        builder: (_, _) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.historyPath,
        name: AppRoutes.history,
        builder: (_, _) => const HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.profilePath,
        name: AppRoutes.profile,
        builder: (_, _) => const ProfileScreen(),
      ),

      // --- Secondary ---------------------------------------------------
      // History and notifications are listed inside Settings but are also
      // reachable from the dashboard header, so they stay top-level rather
      // than nesting under /settings.
      GoRoute(
        path: AppRoutes.notificationsPath,
        name: AppRoutes.notifications,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsPath,
        name: AppRoutes.settings,
        builder: (_, _) => const SettingsScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'change-password',
            name: AppRoutes.changePassword,
            builder: (_, _) => const ChangePasswordScreen(),
          ),
          GoRoute(
            path: 'organisations',
            name: AppRoutes.organisationSettings,
            builder: (_, _) => const OrganisationSettingsScreen(),
            routes: <RouteBase>[
              GoRoute(
                path: 'add',
                name: AppRoutes.addOrganisation,
                builder: (_, _) => const AddOrganisationScreen(),
              ),
              GoRoute(
                path: 'list',
                name: AppRoutes.organisationsList,
                builder: (_, _) => const OrganisationsListScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (_, GoRouterState state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );
}
