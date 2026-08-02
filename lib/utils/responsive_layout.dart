import 'package:flutter/widgets.dart';

import 'package:fluxa/utils/app_breakpoints.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Builds a different subtree per device class.
///
/// Use only when the layout *structure* changes (a column becoming two
/// columns on tablet). For size differences alone prefer `context.r`,
/// `context.wp` or `context.adaptive` — one subtree is cheaper to maintain
/// than four.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.phone,
    this.smallPhone,
    this.largePhone,
    this.tablet,
  });

  final WidgetBuilder phone;
  final WidgetBuilder? smallPhone;
  final WidgetBuilder? largePhone;
  final WidgetBuilder? tablet;

  @override
  Widget build(BuildContext context) {
    return switch (context.deviceType) {
      DeviceType.smallPhone => (smallPhone ?? phone)(context),
      DeviceType.phone => phone(context),
      DeviceType.largePhone => (largePhone ?? phone)(context),
      DeviceType.tablet => (tablet ?? largePhone ?? phone)(context),
    };
  }
}

/// Constrains its child to [ResponsiveContext.contentMaxWidth] and centres it.
///
/// Wrap page bodies with this so content keeps a readable measure on tablets
/// instead of stretching edge to edge.
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
        child: child,
      ),
    );
  }
}
