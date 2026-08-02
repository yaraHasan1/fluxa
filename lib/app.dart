import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

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
