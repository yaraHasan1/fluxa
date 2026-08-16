// status_card.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key, required this.status, this.kilowatts});

  final SystemStatus status;

  /// Null until telemetry answers, and if it never does. The card says so
  /// rather than printing a figure the system did not report.
  final double? kilowatts;

  @override
  Widget build(BuildContext context) {
    final cardHeight = context.hp(0.17);

    return SizedBox(
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: context.r(18),
              vertical: context.r(14),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.r(22)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.teal.withValues(alpha: 0.30),
                  AppColors.teal.withValues(alpha: 0.18),
                ],
              ),
              border: Border.all(
                color: AppColors.teal.withValues(alpha: 0.45),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withValues(alpha: 0.22),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Row(
              children: [
                SizedBox(width: context.wp(0.18)),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Status: ',
                              style: AppTextStyles.fieldLabel.copyWith(
                                fontSize: context.sp(18),
                                fontWeight: FontWeight.w700,
                                color: Colors.black.withValues(alpha: 0.85),
                              ),
                            ),
                            TextSpan(
                              text: status.word,
                              style: AppTextStyles.fieldLabel.copyWith(
                                fontSize: context.sp(18),
                                fontWeight: FontWeight.w900,
                                color: AppColors.teal,
                                shadows: [
                                  Shadow(
                                    color: AppColors.tealDark,
                                    blurRadius: 0,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: context.r(10)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kilowatts?.toStringAsFixed(1) ??
                                AppStrings.noReading,
                            style: AppTextStyles.reading.copyWith(
                              fontSize: context.sp(34),
                              fontWeight: FontWeight.w900,
                              color: AppColors.teal,
                              height: 0.9,
                              shadows: [
                                Shadow(
                                  color: AppColors.tealDark,
                                  blurRadius: 0,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: context.r(8)),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(height: context.r(10)),
                              Text(
                                'kW',
                                style: AppTextStyles.readingUnit.copyWith(
                                  fontSize: context.sp(16),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.teal.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: context.r(10)),

                      Text(
                        status.caption,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.helper.copyWith(
                          fontSize: context.sp(11),
                          color: Colors.black.withValues(alpha: 0.60),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: context.wp(0.02)),

                _EnergyRing(
                  accent: AppColors.teal,
                  diameter: context.r(104),
                  iconPath: status.glyph,
                  iconSize: context.r(66),
                ),
              ],
            ),
          ),

          // Robot outside the card
          Positioned(
            top: -60,
            left: -context.wp(0.06),
            child: SizedBox(
              child: SvgPicture.asset(status.mascot, fit: BoxFit.contain),
            ),
          ),

          // Sun icon
          Positioned(
            top: context.r(10),
            right: context.r(10),
            child: Icon(
              Icons.wb_sunny_rounded,
              color: const Color(0xFFFFB300),
              size: context.r(24),
            ),
          ),
        ],
      ),
    );
  }
}

class _EnergyRing extends StatelessWidget {
  const _EnergyRing({
    required this.accent,
    required this.diameter,
    required this.iconPath,
    required this.iconSize,
  });

  final Color accent;
  final double diameter;
  final String iconPath;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(diameter),
            painter: _RingPainter(accent),
          ),

          SvgPicture.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 12.0;

    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );

    final bg = Paint()
      ..color = color.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawOval(rect, bg);

    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawOval(rect, fg);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
