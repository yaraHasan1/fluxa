import 'package:flutter/material.dart';

import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// A labelled input: caption above, white rounded field below.
///
/// Every form in the flow — login, signup, reset, add organisation — uses this
/// pair, so the label and the field stay locked together rather than being
/// re-spaced per screen.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscure = false,
    this.onToggleObscure,
    this.focusNode,
  });

  final String label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  /// Hides the entered text. When [onToggleObscure] is also supplied the field
  /// grows an eye button that flips it.
  final bool obscure;
  final VoidCallback? onToggleObscure;

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final double radius = context.r(16);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          style: AppTextStyles.fieldLabel.copyWith(fontSize: context.sp(15)),
        ),
        SizedBox(height: context.r(7)),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscure,
          style: AppTextStyles.fieldInput.copyWith(fontSize: context.sp(15)),
          cursorColor: AppColors.teal,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.r(16),
              vertical: context.r(13),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(color: AppColors.teal, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(color: AppColors.teal, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(color: AppColors.teal, width: 2),
            ),
            suffixIcon: onToggleObscure == null
                ? null
                : IconButton(
                    onPressed: onToggleObscure,
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: context.r(19),
                      color: AppColors.tealMid,
                    ),
                    tooltip: obscure ? 'Show password' : 'Hide password',
                  ),
          ),
        ),
      ],
    );
  }
}
