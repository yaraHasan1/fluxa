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

  /// Screen headings — the near-black in the design carries a green cast
  /// rather than the blue one [navy] has.
  static const Color ink = Color(0xFF163740);

  // --- Shell greys (robot chassis) --------------------------------------
  static const Color shellLight = Color(0xFFDBE1EA);
  static const Color shell = Color(0xFFCDD5E0);
  static const Color shellMid = Color(0xFFA4B2C3);
  static const Color shellDark = Color(0xFF8498A5);

  /// The colour every drop shadow in the artwork is tinted with — the Figma
  /// filters all carry `0.454424, 0.725962, 0.666717`. The depth in this design
  /// is a soft mint glow, not a grey shadow.
  static const Color glow = Color(0xFF74B9AA);

  // --- System status -----------------------------------------------------
  // Sampled from the gradient stops inside each mascot export, so the card
  // chrome and the artwork inside it cannot drift apart.

  /// Healthy — reuses the brand teal.
  static const Color statusHealthy = teal;
  static const Color statusHealthySurface = Color(0xFFE7F5F1);

  /// Bad — from fluxa_angry.svg (#FF383C / #CC2427 / #9A1113).
  static const Color statusBad = Color(0xFFFF383C);
  static const Color statusBadDeep = Color(0xFF9A1113);
  static const Color statusBadSurface = Color(0xFFFAD7DA);

  /// Warning — from fluxa_warning.svg (#FFC000 / #F28909).
  static const Color statusWarning = Color(0xFFFFC000);
  static const Color statusWarningDeep = Color(0xFFF28909);
  static const Color statusWarningSurface = Color(0xFFFBF1CC);

  // --- Form chrome -------------------------------------------------------
  /// Hairline around the translucent auth panel.
  static const Color cardBorder = Color(0xFF6FB3AB);

  /// Hairline around a resting input.
  static const Color fieldBorder = Color(0xFFB9D3CF);

  // --- Surfaces ----------------------------------------------------------
  static const Color backgroundTop = Color(0xFFE3ECF1);
  static const Color backgroundBottom = Color(0xFFD3E0E7);

  // --- Deep surface (verification, password recovery) --------------------
  /// Sampled from the teal frames, which invert the palette: saturated ground,
  /// light type.
  static const Color deepTop = Color(0xFF55AC9F);
  static const Color deepBottom = Color(0xFF1F7C71);

  /// Type and chrome that sit *on* the deep surface.
  static const Color onDeep = Color(0xFFF2FBF8);
  static const Color onDeepMuted = Color(0xFFBEE7DE);

  /// Vertical wash for the teal frames.
  static const LinearGradient deepGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[deepTop, deepBottom],
  );

  /// Vertical wash used behind the splash and every full-bleed brand surface.
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[backgroundTop, backgroundBottom],
  );
}
