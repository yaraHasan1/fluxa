/// Single source of truth for every bundled asset path.
///
/// Widgets must never hardcode an asset string — always reference a member of
/// this class so a moved or renamed file is a one-line change.
abstract final class AppAssets {
  static const String _svg = 'assets/svg';

  /// The complete, unmodified mascot exported from Figma.
  /// Use when a static, non-animated logo is required.
  static const String robotFull = '$_svg/fluxa_robot.svg';

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
