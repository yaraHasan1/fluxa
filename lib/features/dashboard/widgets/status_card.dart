import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The headline card: mascot, status word, current reading and status glyph.
///
/// The three variants in the design are one card — [SystemStatus] carries the
/// mascot, glyph, palette and copy, so nothing here branches on the state.
class StatusCard extends StatelessWidget {
  const StatusCard({super.key, required this.status, this.kilowatts});

  final SystemStatus status;

  /// Null renders the reading as a dash rather than inventing a number.
  final double? kilowatts;

  @override
  Widget build(BuildContext context) {
    final double mascotWidth = context.wp(0.24);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: status.surface,
        borderRadius: BorderRadius.circular(context.r(18)),
        border: Border.all(color: status.accent, width: 1.4),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.r(10),
          context.r(12),
          context.r(14),
          context.r(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              status.mascot,
              width: mascotWidth,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
            SizedBox(width: context.r(10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: AppStrings.statusLabel,
                          style: AppTextStyles.fieldLabel.copyWith(
                            fontSize: context.sp(15),
                          ),
                        ),
                        TextSpan(
                          text: status.word,
                          style: AppTextStyles.fieldLabel.copyWith(
                            fontSize: context.sp(15),
                            color: status.ink,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.r(2)),
                  Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: kilowatts == null
                              ? AppStrings.noReading
                              : kilowatts!.toStringAsFixed(1),
                          style: AppTextStyles.reading.copyWith(
                            fontSize: context.sp(30),
                            color: status.ink,
                          ),
                        ),
                        TextSpan(
                          text: AppStrings.kilowattSuffix,
                          style: AppTextStyles.readingUnit.copyWith(
                            fontSize: context.sp(14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.r(4)),
                  Text(
                    status.caption,
                    style: AppTextStyles.helper.copyWith(
                      fontSize: context.sp(10.5),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.r(8)),
            _StatusGlyph(status: status, diameter: context.r(58)),
          ],
        ),
      ),
    );
  }
}

/// The glyph in its ring. Each export has its own aspect, so the artwork is
/// height-constrained inside a fixed circle rather than stretched to fill it.
class _StatusGlyph extends StatelessWidget {
  const _StatusGlyph({required this.status, required this.diameter});

  final SystemStatus status;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: status.accent, width: diameter * 0.07),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        status.glyph,
        height: diameter * 0.5,
        fit: BoxFit.contain,
        excludeFromSemantics: true,
      ),
    );
  }
}
