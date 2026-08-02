/// Device classes the UI adapts to.
enum DeviceType { smallPhone, phone, largePhone, tablet }

/// Width breakpoints, measured on the *shortest* side so orientation changes
/// do not reclassify a device.
abstract final class AppBreakpoints {
  static const double smallPhone = 360;
  static const double phone = 400;
  static const double largePhone = 600;

  /// Figma frame the designs were authored against.
  static const double designWidth = 375;
  static const double designHeight = 812;

  static DeviceType resolve(double shortestSide) {
    if (shortestSide >= largePhone) return DeviceType.tablet;
    if (shortestSide >= phone) return DeviceType.largePhone;
    if (shortestSide >= smallPhone) return DeviceType.phone;
    return DeviceType.smallPhone;
  }
}
