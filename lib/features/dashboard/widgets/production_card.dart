import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/components/outlined_rich_text.dart'
    show OutlinedRichText, TextRun;
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The expanded read-out for a single production source: title, icon, the
/// figure, and a line explaining what the reading means.
///
/// One widget for all three sources — [EnergySourceKind] supplies the icon and
/// the palette, so adding a fourth source is an enum case, not a new card.
class ProductionCard extends StatelessWidget {
  const ProductionCard({
    super.key,
    required this.kind,
    required this.value,
    required this.unit,
    required this.caption,
    this.badge,
  });

  final EnergySourceKind kind;

  /// Null until telemetry reports this source.
  final double? value;

  /// What [value] is measured in; the three sources do not share one.
  final String unit;

  /// The explanatory line under the figure.
  final String caption;

  /// Small pill beside the icon — the battery's charge level, for instance.
  /// Null on sources that have nothing to report.
  final String? badge;

  /// The card's edge, which is what distinguishes the three at a glance.
  Color get _edge => switch (kind) {
    EnergySourceKind.solar => AppColors.statusWarning,
    EnergySourceKind.grid => AppColors.shellDark,
    EnergySourceKind.battery => AppColors.teal,
  };

  /// Only solar carries its colour into the figure; the other two read grey,
  /// as in the design.
  Color get _figure => switch (kind) {
    EnergySourceKind.solar => AppColors.statusWarningDeep,
    EnergySourceKind.grid => AppColors.shellDark,
    EnergySourceKind.battery => AppColors.shellDark,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.r(12)),
      decoration: BoxDecoration(
        color: AppColors.shellLight.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(context.r(14)),
        border: Border.all(color: _edge, width: context.r(2)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.glow.withValues(alpha: 0.35),
            blurRadius: context.r(12),
            offset: Offset(0, context.r(4)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  AppStrings.currentProduction,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: context.sp(12),
                  ),
                ),
              ),
              SizedBox(width: context.r(8)),
              _Glyph(kind: kind, badge: badge),
            ],
          ),
          SizedBox(height: context.r(6)),
          OutlinedRichText(
            outline: AppColors.ink,
            strokeWidth: context.r(2),
            spans: <TextRun>[
              TextRun(
                value?.toStringAsFixed(1) ?? AppStrings.noReading,
                AppTextStyles.reading.copyWith(
                  fontSize: context.sp(28),
                  color: _figure,
                ),
              ),
              TextRun(
                ' $unit',
                AppTextStyles.readingUnit.copyWith(
                  fontSize: context.sp(13),
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          SizedBox(height: context.r(8)),
          Text(
            caption,
            style: AppTextStyles.helper.copyWith(
              fontSize: context.sp(11),
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// The source icon, with its optional reading pill tucked under it.
class _Glyph extends StatelessWidget {
  const _Glyph({required this.kind, required this.badge});

  final EnergySourceKind kind;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final Widget icon = SvgPicture.asset(
      kind.icon,
      height: context.r(34),
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    );

    if (badge == null) return icon;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        icon,
        SizedBox(height: context.r(3)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.r(5),
            vertical: context.r(1),
          ),
          decoration: BoxDecoration(
            color: AppColors.mintDeep,
            borderRadius: BorderRadius.circular(context.r(4)),
          ),
          child: Text(
            badge!,
            style: AppTextStyles.helper.copyWith(
              fontSize: context.sp(8),
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
