import 'package:flutter/material.dart';

/// Placeholder for the Organisation Settings screen.
///
/// Structure only: no colours, assets, icons or motion from the design yet.
/// The body is replaced when the corresponding Figma frame is implemented.
class OrganisationSettingsScreen extends StatelessWidget {
  const OrganisationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: Text('Organisation Settings'))),
    );
  }
}
