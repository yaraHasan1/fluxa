import 'package:flutter/material.dart';

/// Placeholder for the Login screen.
///
/// Structure only: no colours, assets, icons or motion from the design yet.
/// The body is replaced when the corresponding Figma frame is implemented.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: Text('Login'))),
    );
  }
}
