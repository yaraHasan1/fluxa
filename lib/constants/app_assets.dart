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
  static const String FluxabIG = '$_svg/FLUXABIG.svg';

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

  /// The chest bolt, extracted from [splashArt] at the *same* 313×372 viewBox.
  /// Laying it out over the art at equal width registers it exactly, with no
  /// hand-tuned offset to drift when the art is re-exported.
  static const String splashBolt = '$_svg/splash_bolt.svg';

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
