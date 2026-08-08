/// Every navigable destination in the app.
///
/// Paths and names are declared once here so no widget ever carries a raw
/// route string. Nested paths are expressed relative to their parent, with a
/// `*Path` constant for the absolute form used by `go`/`goNamed`.
abstract final class AppRoutes {
  // --- Boot ------------------------------------------------------------
  static const String splash = 'splash';
  static const String splashPath = '/';

  static const String onboarding = 'onboarding';
  static const String onboardingPath = '/onboarding';

  // --- Authentication --------------------------------------------------
  static const String auth = 'auth';
  static const String authPath = '/auth';

  static const String login = 'login';
  static const String loginPath = '$authPath/login';

  static const String signup = 'signup';
  static const String signupPath = '$authPath/signup';

  static const String verification = 'verification';
  static const String verificationPath = '$authPath/verification';

  static const String forgetPassword = 'forget-password';
  static const String forgetPasswordPath = '$authPath/forget-password';

  /// Query keys on the shared verification frame. [flowParam] selects where
  /// "confirm" goes; [emailParam] carries the address to display.
  static const String flowParam = 'flow';
  static const String emailParam = 'email';
  static const String recoveryFlow = 'recovery';

  /// Final step of the recovery flow — enter and confirm a new password.
  static const String resetPassword = 'reset-password';
  static const String resetPasswordPath = '$forgetPasswordPath/reset';

  // --- Main shell ------------------------------------------------------

  static const String dashboard = 'dashboard';
  static const String dashboardPath = '/dashboard';

  static const String history = 'history';
  static const String historyPath = '/history';

  // --- Secondary -------------------------------------------------------
  static const String notifications = 'notifications';
  static const String notificationsPath = '/notifications';

  static const String settings = 'settings';
  static const String settingsPath = '/settings';

  static const String changePassword = 'change-password';
  static const String changePasswordPath = '$settingsPath/change-password';

  // --- Organisations ---------------------------------------------------
  static const String organisationSettings = 'organisation-settings';
  static const String organisationSettingsPath = '$settingsPath/organisations';

  static const String addOrganisation = 'add-organisation';
  static const String addOrganisationPath = '$organisationSettingsPath/add';

  static const String requestSent = 'request-sent';
  static const String requestSentPath = '$organisationSettingsPath/sent';

  static const String organisationsList = 'organisations-list';
  static const String organisationsListPath = '$organisationSettingsPath/list';
}
