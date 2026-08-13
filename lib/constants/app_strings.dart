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
  static const String haveAccountPrompt = 'Already have account ! ';

  // --- Verification ------------------------------------------------------
  static const String verificationPrompt =
      'verification code  send the code to this  email :';

  /// Stand-in shown only until a real address is routed in. The frame is
  /// mocked up with this literal.
  static const String emailPlaceholder = 'xxxx@gmail.com';

  /// The design frame spells this "Didn't Recieve A code?"; corrected here.
  static const String noCodePrompt = "Didn't Receive A code? ";
  static const String resendCode = 'Resend Code';
  static const String confirm = 'confirm';

  // --- Password recovery -------------------------------------------------
  static const String resetPrompt = 'To reset the password\nEnter the email';
  static const String newPasswordTitle = 'Enter New Password :';

  // --- Dashboard ---------------------------------------------------------
  static const String greetingPrefix = 'Good morning ';
  static const String greetingSubtitle = "here's your system overview";

  static const String currentConsumption = 'Current consumption';
  static const String currentProduction = 'Current production';
  static const String productionCaptionElectricity =
      'Current consumption is not\nfrom solar electricity';
  static const String productionCaptionEnergy =
      'Current consumption is not\nfrom solar energy';
  static const String energySources = 'Energy sources';
  static const String energySourcesCaption =
      'Current production for each source';
  static const String circuitBreakers = 'Circuit breakers';

  static const String statusLabel = 'Status: ';
  static const String statusHealthy = 'Healthy';
  static const String statusBad = 'BAD';
  static const String statusWarning = 'Warning';

  static const String statusHealthyCaption = 'everything is running smoothly';
  static const String statusBadCaption = 'There is an overload';
  static const String statusWarningCaption =
      'Better to keep an eye on your system';

  static const String kilowattSuffix = 'kw';

  static const String notifications = 'Notifications';
  static const String settings = 'Settings';

  // --- Settings ----------------------------------------------------------
  static const String settingsTitle = 'settings';
  static const String organisationalSettings = 'Organizational settings';
  static const String history = 'history';
  static const String notificationsRow = 'notifications';
  static const String changePassword = 'change password';

  static const String companyName = 'Company Name';
  static const String addOrganisation = 'Add organisation';
  static const String organisationalChange = 'Organizational change';

  static const String addOrganisationTitle = 'Add organization';
  static const String organisationNameLabel = 'name';
  static const String organisationSizeLabel = 'size';
  static const String submit = 'Submit';

  static const String organisationsListTitle = 'List of organizations';

  // --- History and notifications ----------------------------------------
  static const String historyTitle = 'history';
  static const String notificationsTitle = 'notifications';
  static const String breakerOff = 'off';
  static const String breakerOn = "on";
  static const String actionSwitchedOn = "The breaker was switched on";
  static const String actionSwitchedOff = "The breaker was switched off";
  static const String historyEmpty = "No switches recorded yet.";
  static const String genericError = "Something went wrong. Please try again.";
  static const String signedIn = "Signed in successfully.";

  /// Stand-in copy from the frames, used until the backend supplies events.
  static const String historySample = 'There was not enough production';
  static const String notificationSample =
      "The air conditioner's circuit breaker tripped due to insufficient power output.";

  static const String requestSent =
      'We will send you the approval after\nreviewing your request.';

  /// Shown in place of a reading that has not arrived.
  static const String noReading = '--';
}
