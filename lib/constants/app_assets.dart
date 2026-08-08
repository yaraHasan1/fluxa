/// Single source of truth for every bundled asset path.
///
/// Widgets must never hardcode an asset string — always reference a member of
/// this class so a moved or renamed file is a one-line change.
abstract final class AppAssets {
  static const String _svg = 'assets/svg';

  /// The complete, unmodified mascot exported from Figma.
  /// Use when a static, non-animated logo is required.
  static const String robotFull = '$_svg/fluxa_robot.svg';

  /// A wide mascot export used on social and onboarding screens.
  static const String fluxaBig = '$_svg/FLUXABIG.svg';

  /// A full-screen brand background used on the login and welcome frames.
  static const String fluxaBackground = '$_svg/FluxaBackround.svg';

  /// The full splash centrepiece (313×372): mascot, antenna waves, the floating
  /// power button and the swooping cable tail, composed as one group.
  ///
  /// Wider than [robotFull], which is the mascot alone.
  static const String splashArt = '$_svg/splash_art.svg';

  /// The cable tail that sweeps beneath the mascot (342×191). Sits *under*
  /// [splashArt] in the stack.
  static const String splashSwoosh = '$_svg/splash_swoosh.svg';
  static const String loginUnder = '$_svg/loginUnder.svg';

  /// The chest bolt, extracted from [splashArt] at the *same* 313×372 viewBox.
  /// Laying it out over the art at equal width registers it exactly, with no
  /// hand-tuned offset to drift when the art is re-exported.
  static const String splashBolt = '$_svg/splash_bolt.svg';

  /// Full-frame watermark (440×956). The export carries `opacity="0.1"`
  /// itself, so it is drawn at full strength — dimming it again would sink it
  /// into the background.

  /// Side-on mascot (159×251) used on the onboarding frame.
  static const String fluxaSide = '$_svg/fluxa_side.svg';

  /// Arrow-into-door glyph (44×38) for the login action.
  static const String loginIcon = '$_svg/login_icon.svg';

  // --- Dashboard status --------------------------------------------------
  /// One mascot per system state, each with its own palette baked in.
  static const String fluxaHappy = '$_svg/fluxa_happy.svg'; // 183×280
  static const String fluxaAngry = '$_svg/fluxa_angry.svg'; // 163×263
  static const String fluxaWarning = '$_svg/fluxa_warning.svg'; // 188×281

  /// Energy source icons.
  static const String iconSolar = '$_svg/icon_solar.svg'; // 39×43
  static const String iconWind = '$_svg/icon_wind.svg'; // 38×38
  static const String iconBattery = '$_svg/icon_battery.svg'; // 31×44

  /// Circuit breaker device icons. The air conditioner is still outstanding.
  static const String iconPc = '$_svg/icon_pc.svg'; // 38×31
  static const String iconServer = '$_svg/icon_server.svg'; // 30×36

  /// The glyph beside each status reading.
  static const String iconEnergy = '$_svg/energy.svg'; // 174×197, teal
  static const String iconFire = '$_svg/icon_fire.svg'; // 94×108, red
  static const String iconAlert = '$_svg/icon_alert.svg'; // 11×59, amber

  /// The ribbon that sweeps under the LOGIN wordmark (423×271). Carries its
  /// own linear gradient — shell grey into teal into navy — so it must not be
  /// recoloured.
  static const String loginRibbon = '$_svg/login_ribbon.svg';

  /// Three broadcast arcs radiating from a corner (170×167). Drawn once for
  /// the top-left and again, half-turned, for the bottom-right.
  static const String cornerArcs = '$_svg/corner_arcs.svg';

  /// [cornerArcs] split into its three concentric arcs so they can be lit in
  /// sequence. Ordered innermost → outermost; each keeps the full viewBox, so
  /// stacking them reproduces [cornerArcs] exactly.
  static const List<String> cornerArcLayers = <String>[
    '$_svg/corner_arc_1.svg',
    '$_svg/corner_arc_2.svg',
    '$_svg/corner_arc_3.svg',
  ];

  // --- Animatable layers -----------------------------------------------
  // Every layer below shares the source `viewBox="0 0 231 358"`, so stacking
  // them in an equally sized box reproduces the original artwork exactly
  // while letting each part carry its own animation.

  /// Tail, plug, ears, head shell, face screen, body, arms and chest disc.
  static const String robotBase = '$_svg/robot_base.svg';

  /// Antenna broadcast arcs, ordered from the head outwards.
  static const String robotWaveInner = '$_svg/robot_wave_inner.svg';
  static const String robotWaveMid = '$_svg/robot_wave_mid.svg';
  static const String robotWaveOuter = '$_svg/robot_wave_outer.svg';

  /// Both eyes, so a blink stays synchronised.
  static const String robotEyes = '$_svg/robot_eyes.svg';

  static const String robotMouth = '$_svg/robot_mouth.svg';

  /// Chest lightning bolt.
  static const String robotBolt = '$_svg/robot_bolt.svg';

  /// Antenna arcs ordered inner → outer, for staggered sequencing.
  static const List<String> robotWaves = <String>[
    robotWaveInner,
    robotWaveMid,
    robotWaveOuter,
  ];
}
