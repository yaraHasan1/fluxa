import 'package:flutter/material.dart';

/// Brand palette, sampled directly from the gradient stops of the Figma SVG
/// export so the Flutter UI and the vector artwork stay in perfect agreement.
abstract final class AppColors {
  // --- Mint (highlights: eyes, mouth, bolt, antenna waves) ---------------
  static const Color mintLight = Color(0xFF94EAD4);
  static const Color mint = Color(0xFF93E9D3);
  static const Color mintDeep = Color(0xFF54BDA8);

  // --- Teal (wordmark, ears, cable) -------------------------------------
  static const Color tealBright = Color(0xFF3EBCB3);
  static const Color teal = Color(0xFF17867E);
  static const Color tealMid = Color(0xFF136D66);
  static const Color tealDark = Color(0xFF0E534E);

  // --- Navy (face screen, chest disc) -----------------------------------
  static const Color navy = Color(0xFF182941);

  // --- Shell greys (robot chassis) --------------------------------------
  static const Color shellLight = Color(0xFFDBE1EA);
  static const Color shell = Color(0xFFCDD5E0);
  static const Color shellMid = Color(0xFFA4B2C3);
  static const Color shellDark = Color(0xFF8498A5);

  // --- Surfaces ----------------------------------------------------------
  static const Color backgroundTop = Color(0xFFE3ECF1);
  static const Color backgroundBottom = Color(0xFFD3E0E7);

  /// Vertical wash used behind the splash and every full-bleed brand surface.
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[backgroundTop, backgroundBottom],
  );

  /// Mint→teal sweep used by the decorative corner arcs.
  static const LinearGradient arcGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[mintLight, mintDeep, teal],
    stops: <double>[0.0, 0.55, 1.0],
  );
}
