import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Navigation helpers shared by the back controls.
extension AppNav on BuildContext {
  /// Pops if there is anything below, otherwise goes to [fallbackRoute].
  ///
  /// Every screen here is reached with `go`, which rebuilds the stack from the
  /// matched route hierarchy. A screen entered at the top of its branch —
  /// settings arriving from the dashboard, say — therefore has nothing to pop,
  /// and a bare `pop()` would either throw or do nothing at all. The fallback
  /// is where "back" means "up one level" rather than "the previous page".
  void backOr(String fallbackRoute) {
    if (canPop()) {
      pop();
    } else {
      goNamed(fallbackRoute);
    }
  }
}
