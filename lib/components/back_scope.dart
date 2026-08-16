import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Makes the platform back gesture step *up* a level instead of leaving the
/// app.
///
/// Screens here are reached with `go`, which rebuilds the stack from the
/// matched route hierarchy. One entered at the top of its branch — settings
/// arriving from the dashboard, say — has nothing to pop, and the system back
/// would close the app rather than return. This sends it to [upRoute] instead,
/// which is wherever the screen's own chevron goes, so the two controls agree.
///
/// A screen that does have something below it pops as normal.
class BackScope extends StatelessWidget {
  const BackScope({super.key, required this.upRoute, required this.child});

  /// The route name one level up.
  final String upRoute;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: context.canPop(),
      onPopInvokedWithResult: (bool didPop, Object? _) {
        if (didPop) return;
        context.goNamed(upRoute);
      },
      child: child,
    );
  }
}
