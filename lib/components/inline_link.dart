import 'package:flutter/material.dart';

import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Small print ending in one tappable run — "Don't have account ! **Sign Up**".
///
/// Only [action] is styled as the link, but the whole line is the tap target:
/// the bold run alone is a few millimetres wide and would be an awkward hit
/// area on a phone.
class InlineLink extends StatelessWidget {
  const InlineLink({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
    this.align = TextAlign.center,
    this.promptStyle,
    this.actionStyle,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;
  final TextAlign align;

  /// Override for the deep-teal frames, where the light-surface helper colours
  /// would be unreadable.
  final TextStyle? promptStyle;
  final TextStyle? actionStyle;

  @override
  Widget build(BuildContext context) {
    final double size = context.sp(11.5);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        button: true,
        label: '$prompt$action',
        // The spans each publish their own node, which would leave a screen
        // reader announcing the line twice and split the label in two.
        excludeSemantics: true,
        child: Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: prompt,
                style: (promptStyle ?? AppTextStyles.helper).copyWith(
                  fontSize: size,
                ),
              ),
              TextSpan(
                text: action,
                style: (actionStyle ?? AppTextStyles.helperAction).copyWith(
                  fontSize: size,
                ),
              ),
            ],
          ),
          textAlign: align,
        ),
      ),
    );
  }
}
