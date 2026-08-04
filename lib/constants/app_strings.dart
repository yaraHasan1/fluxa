/// User-facing copy. Kept centralised so localisation can be introduced later
/// without touching any widget.
abstract final class AppStrings {
  static const String appName = 'FLUXA';

  /// The tagline is rendered as two runs: [taglineLead] regular, [taglineAccent]
  /// bold — matching the Figma treatment of "Control the **Flow**".
  static const String taglineLead = 'Control the ';
  static const String taglineAccent = 'Flow';

  static const String semanticsLogo = 'Fluxa mascot';

  // --- Onboarding --------------------------------------------------------
  static const String welcomeTitle = 'Welcome';
  static const String welcomeBody =
      'Built to make energy management effortless, intuitive and smart';
  static const String next = 'next';

  // --- Login -------------------------------------------------------------
  static const String loginTitle = 'LOGIN';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String forgotPasswordPrompt = 'Did you forget your password? ';
  static const String resetPassword = 'Reset password';
  static const String login = 'Login';

  /// The design frame spells this "SginUp"; corrected here.
  static const String noAccountPrompt = "Don't have account ! ";
  static const String signUp = 'Sign Up';

  // --- Sign up -----------------------------------------------------------
  static const String signUpTitle = 'Sign Up';
  static const String fullName = 'Full name';
  static const String confirmPassword = 'Confirm Password';
  static const String signUpAction = 'sign up';
}
