import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/features/reset_password/reset_password_screen.dart';

/// Changing the password from settings is the same frame as the last step of
/// password recovery, so it delegates rather than duplicating the layout.
/// Only the destination differs: this one returns to settings.
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResetPasswordScreen(onConfirm: (_) => context.pop());
  }
}
