import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// One line in the settings panel: a bullet, the label, its glyph, and a rule
/// underneath.
///
/// The rule is drawn here rather than as a separator between rows so the last
/// row keeps it too, as the design has it.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.label,
    required this.iconAsset,
    required this.onTap,
  });

  final String label;
  final String iconAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.r(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: context.r(7),
                  height: context.r(7),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.teal,
                  ),
                ),
                SizedBox(width: context.r(10)),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontSize: context.sp(13),
                      color: AppColors.tealDark,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  iconAsset,
                  height: context.r(16),
                  fit: BoxFit.contain,
                  excludeFromSemantics: true,
                ),
              ],
            ),
            SizedBox(height: context.r(8)),
            Padding(
              padding: EdgeInsets.only(left: context.r(17)),
              child: Divider(
                height: 1,
                thickness: 1,
                color: AppColors.teal.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
