import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/features/forget_password/forget_password_screen.dart';
import 'package:fluxa/features/reset_password/reset_password_screen.dart';
import 'package:fluxa/features/login/login_screen.dart';
import 'package:fluxa/features/signup/signup_screen.dart';
import 'package:fluxa/features/verification/verification_screen.dart';
import 'package:fluxa/features/dashboard/dashboard_screen.dart';
import 'package:fluxa/features/history/history_screen.dart';
import 'package:fluxa/features/notifications/notifications_screen.dart';
import 'package:fluxa/features/onboarding/onboarding_screen.dart';
import 'package:fluxa/features/add_organisation/add_organisation_screen.dart';
import 'package:fluxa/features/organisation_settings/organisation_settings_screen.dart';
import 'package:fluxa/features/organisations_list/organisations_list_screen.dart';
import 'package:fluxa/features/change_password/change_password_screen.dart';
import 'package:fluxa/features/settings/settings_screen.dart';
import 'package:fluxa/features/splash/splash_screen.dart';
import 'package:fluxa/routes/app_routes.dart';

/// The application router.
///
/// Routes are declared flat: the design has no bottom navigation bar, so
/// every destination is a plain push/pop on one stack. `/auth` and
/// `/settings` nest their sub-flows so back behaviour follows the URL.
///
/// No `redirect` guard is wired yet — it is added when login has a real
/// session source to read from.
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
        // Only bounce a bare /auth to the login form. go_router runs the
        // redirects of every matched route in the chain, so an unconditional
        // one here would swallow /auth/signup, /auth/verification and the
        // password routes as well.
        redirect: (_, GoRouterState state) =>
            state.uri.path == AppRoutes.authPath ? AppRoutes.loginPath : null,
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
        path: AppRoutes.dashboardPath,
        name: AppRoutes.dashboard,
        builder: (_, _) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.historyPath,
        name: AppRoutes.history,
        builder: (_, _) => const HistoryScreen(),
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
    errorBuilder: (_, GoRouterState state) =>
        Scaffold(body: Center(child: Text('Route not found: ${state.uri}'))),
  );
}
