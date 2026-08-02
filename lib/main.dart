import 'package:flutter/material.dart';

import 'package:fluxa/app.dart';
import 'package:fluxa/utils/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase.initializeApp() belongs here, before the container is built.
  await configureDependencies();

  runApp(const FluxaApp());
}
