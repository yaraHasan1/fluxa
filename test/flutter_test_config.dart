import 'dart:async';

import 'package:fluxa/utils/injector.dart';

/// Flutter runs this before the tests in this directory.
///
/// Screens resolve their collaborators from the service locator, so the graph
/// has to exist before any of them is pumped. Wiring it here means no test
/// file has to remember to.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await configureDependencies();
  await testMain();
}
