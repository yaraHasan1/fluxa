import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/components/outlined_rich_text.dart'
    show OutlinedRichText, TextRun;
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The production columns, split by hairline dividers.
class EnergySourcesCard extends StatelessWidget {
  const EnergySourcesCard({super.key, required this.sources});

  final List<EnergySource> sources;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.glow.withValues(alpha: 0.35),
            blurRadius: context.r(14),
            offset: Offset(0, context.r(5)),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.r(14)),
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              for (int i = 0; i < sources.length; i++) ...<Widget>[
                if (i > 0)
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    indent: context.r(2),
                    endIndent: context.r(2),
                    color: AppColors.tealBright.withValues(alpha: 0.55),
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
        SvgPicture.asset(
          source.kind.icon,
          height: context.r(30),
          fit: BoxFit.contain,
          excludeFromSemantics: true,
        ),
        SizedBox(height: context.r(8)),
        OutlinedRichText(
          outline: AppColors.ink,
          strokeWidth: context.r(2),
          spans: <TextRun>[
            TextRun(
              source.value?.toStringAsFixed(1) ?? AppStrings.noReading,
              AppTextStyles.reading.copyWith(
                fontSize: context.sp(17),
                color: source.kind.accent,
              ),
            ),
            TextRun(
              source.unit,
              AppTextStyles.readingUnit.copyWith(fontSize: context.sp(11)),
            ),
          ],
        ),
      ],
    );
  }
}
