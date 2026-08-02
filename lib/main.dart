import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase.initializeApp() belongs here, before the container is built.
  await configureDependencies();

  runApp(const FluxaApp());
}
