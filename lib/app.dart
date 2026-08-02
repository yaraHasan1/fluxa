import 'package:flutter/material.dart';

import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/routes/app_router.dart';
import 'package:fluxa/theme/app_theme.dart';

/// Root widget.
///
/// Global Blocs are provided here (wrapped in a `MultiBlocProvider`) once any
/// exist; today the tree is just router + theme.
class FluxaApp extends StatelessWidget {
  const FluxaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
