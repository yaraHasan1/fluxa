import 'package:flutter/material.dart';

import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Shows a short message across the bottom of the screen.
///
/// One helper for both outcomes so screens do not each assemble a SnackBar:
/// green for success, red for failure, everything else identical.
void showAppMessage(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context)
    // Replace whatever is showing, so a burst of results does not queue up
    // behind an old message the user has moved past.
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.button.copyWith(fontSize: context.sp(13)),
        ),
        backgroundColor: isError ? AppColors.statusBadDeep : AppColors.teal,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(context.r(14)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.r(12)),
        ),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
}
