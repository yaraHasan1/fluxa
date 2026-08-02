import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'app_breakpoints.dart';

/// Viewport-aware sizing helpers.
///
/// Layouts express size as a *fraction* of the viewport ([wp]/[hp]) or as a
/// design-frame value scaled by a damped factor ([r]/[sp]). Nothing in the UI
/// should carry a raw pixel constant that must hold across form factors.
extension ResponsiveContext on BuildContext {
  Size get _size => MediaQuery.sizeOf(this);

  double get screenWidth => _size.width;
  double get screenHeight => _size.height;
  double get shortestSide => _size.shortestSide;

  DeviceType get deviceType => AppBreakpoints.resolve(shortestSide);

  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isSmallPhone => deviceType == DeviceType.smallPhone;
  bool get isLandscape => _size.width > _size.height;

  /// Fraction of the viewport width. `context.wp(0.12)` == 12% of the width.
  double wp(double fraction) => _size.width * fraction;

  /// Fraction of the viewport height.
  double hp(double fraction) => _size.height * fraction;

  /// Scale factor relative to the 375pt design frame.
  ///
  /// Damped and clamped: phones track the design closely, while tablets grow
  /// sub-linearly so a 2× wider screen does not produce 2× larger type.
  double get scaleFactor {
    final double raw = shortestSide / AppBreakpoints.designWidth;
    final double damped = raw > 1 ? 1 + (raw - 1) * 0.45 : raw;
    return damped.clamp(0.82, 1.35);
  }

  /// Scales a design-frame dimension (padding, radius, icon box).
  double r(double designValue) => designValue * scaleFactor;

  /// Scales a design-frame font size, honouring the user's text-scale setting
  /// but capping it so the brand lockup cannot overflow.
  double sp(double designFontSize) {
    final double textScale =
        MediaQuery.textScalerOf(this).scale(1).clamp(1.0, 1.3);
    return designFontSize * scaleFactor * textScale;
  }

  /// Picks the value matching the current device class, falling back down the
  /// chain when a tier is not supplied.
  T adaptive<T>({
    required T phone,
    T? smallPhone,
    T? largePhone,
    T? tablet,
  }) =>
      switch (deviceType) {
        DeviceType.smallPhone => smallPhone ?? phone,
        DeviceType.phone => phone,
        DeviceType.largePhone => largePhone ?? phone,
        DeviceType.tablet => tablet ?? largePhone ?? phone,
      };

  /// Width the content column should occupy. On tablets the brand lockup is
  /// centred in a readable measure instead of stretching edge to edge.
  double get contentMaxWidth =>
      isTablet ? math.min(screenWidth * 0.62, 520) : screenWidth;
}
