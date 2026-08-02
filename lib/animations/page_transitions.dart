import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/animations/animation_constants.dart';

/// The kinds of route motion the app uses. Keeping this an enum (rather than
/// letting callers hand-roll builders) is what guarantees consistency.
enum FluxaTransition {
  /// Cross-fade with a barely perceptible scale — for brand / hand-off moments.
  fade,

  /// Horizontal push — for forward navigation within a flow.
  slideFromRight,

  /// Vertical rise — for modals and sheets.
  slideFromBottom,

  /// Scale up from centre — for detail views expanding from a tapped card.
  scale,
}

/// Builds the animated child for a given [FluxaTransition].
Widget _buildTransition(
  FluxaTransition type,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final Animation<double> eased = CurvedAnimation(
    parent: animation,
    curve: AppCurves.enter,
    reverseCurve: AppCurves.exit,
  );

  // The outgoing route always fades slightly and recedes, so layers read as
  // stacked depth instead of two flat images swapping.
  final Animation<double> outgoing = CurvedAnimation(
    parent: secondaryAnimation,
    curve: AppCurves.standard,
  );

  final Widget receding = FadeTransition(
    opacity: Tween<double>(begin: 1, end: 0.72).animate(outgoing),
    child: child,
  );

  return switch (type) {
    FluxaTransition.fade => FadeTransition(
      opacity: eased,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.03, end: 1).animate(eased),
        child: receding,
      ),
    ),
    FluxaTransition.slideFromRight => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.18, 0),
        end: Offset.zero,
      ).animate(eased),
      child: FadeTransition(opacity: eased, child: receding),
    ),
    FluxaTransition.slideFromBottom => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.12),
        end: Offset.zero,
      ).animate(eased),
      child: FadeTransition(opacity: eased, child: receding),
    ),
    FluxaTransition.scale => ScaleTransition(
      scale: Tween<double>(begin: 0.92, end: 1).animate(eased),
      child: FadeTransition(opacity: eased, child: receding),
    ),
  };
}

/// GoRouter page factory. Use in every `GoRoute.pageBuilder` so declarative
/// routes share the motion system.
CustomTransitionPage<T> fluxaPage<T>({
  required Widget child,
  required LocalKey key,
  FluxaTransition transition = FluxaTransition.fade,
  Duration? duration,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration ?? AppDurations.route,
    reverseTransitionDuration: AppDurations.routeReverse,
    transitionsBuilder: (_, animation, secondaryAnimation, child) =>
        _buildTransition(transition, animation, secondaryAnimation, child),
  );
}

/// Imperative equivalent, for the occasional `Navigator.push` outside the
/// router (dialog-hosted flows, previews).
PageRouteBuilder<T> fluxaRoute<T>({
  required WidgetBuilder builder,
  FluxaTransition transition = FluxaTransition.slideFromRight,
  RouteSettings? settings,
  Duration? duration,
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: duration ?? AppDurations.route,
    reverseTransitionDuration: AppDurations.routeReverse,
    pageBuilder: (context, _, _) => builder(context),
    transitionsBuilder: (_, animation, secondaryAnimation, child) =>
        _buildTransition(transition, animation, secondaryAnimation, child),
  );
}

/// Installed in [ThemeData.pageTransitionsTheme] so even routes created by
/// framework widgets (e.g. `showSearch`) inherit Fluxa's motion.
class FluxaPageTransitionsBuilder extends PageTransitionsBuilder {
  const FluxaPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _buildTransition(
      FluxaTransition.slideFromRight,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
