import 'package:flutter/material.dart';

import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The three production columns, split by hairline dividers.
class EnergySourcesCard extends StatelessWidget {
  const EnergySourcesCard({super.key, required this.sources});

  final List<EnergySource> sources;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.r(12)),
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              for (int i = 0; i < sources.length; i++) ...<Widget>[
                if (i > 0)
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    indent: context.r(4),
                    endIndent: context.r(4),
                    color: AppColors.fieldBorder,
                  ),
                Expanded(child: _SourceColumn(source: sources[i])),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceColumn extends StatelessWidget {
  const _SourceColumn({required this.source});

  final EnergySource source;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // PLACEHOLDER: the solar / wind / battery artwork has not been
        // supplied yet. Swapping these three for SvgPicture.asset is the only
        // change needed once it arrives.
        Icon(
          switch (source.kind) {
            EnergySourceKind.solar => Icons.wb_sunny,
            EnergySourceKind.wind => Icons.air,
            EnergySourceKind.battery => Icons.battery_charging_full,
          },
          size: context.r(26),
          color: switch (source.kind) {
            EnergySourceKind.solar => AppColors.statusWarning,
            EnergySourceKind.wind => AppColors.tealBright,
            EnergySourceKind.battery => AppColors.mintDeep,
          },
        ),
        SizedBox(height: context.r(6)),
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: source.kilowatts.toStringAsFixed(1),
                style: AppTextStyles.reading.copyWith(
                  fontSize: context.sp(15),
                  color: AppColors.teal,
                ),
              ),
              TextSpan(
                text: AppStrings.kilowattSuffix,
                style: AppTextStyles.readingUnit.copyWith(
                  fontSize: context.sp(10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
