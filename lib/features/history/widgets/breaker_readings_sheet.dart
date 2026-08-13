import 'package:flutter/material.dart';

import 'package:fluxa/api/breakers_api.dart';
import 'package:fluxa/components/reading_row.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Shows the readings captured with a switch.
///
/// A dialog rather than a route: it is a detail of the row behind it, and the
/// barrier plus the close button are both ways back out.
Future<void> showBreakerReadings(BuildContext context, BreakerAction action) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _BreakerReadingsSheet(action: action),
  );
}

class _BreakerReadingsSheet extends StatelessWidget {
  const _BreakerReadingsSheet({required this.action});

  final BreakerAction action;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundTop,
      insetPadding: EdgeInsets.symmetric(
        horizontal: context.wp(0.06),
        vertical: context.hp(0.08),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(16)),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.r(16),
          context.r(10),
          context.r(16),
          context.r(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    action.breakerName,
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontSize: context.sp(16),
                      color: AppColors.teal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                InkResponse(
                  onTap: () => Navigator.of(context).pop(),
                  radius: context.r(18),
                  child: Icon(
                    Icons.close,
                    size: context.r(18),
                    color: AppColors.tealDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.r(10)),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _Section(
                      title: AppStrings.breakerStatusTitle,
                      readings: action.breakerStatus,
                    ),
                    _Section(
                      title: AppStrings.telemetryTitle,
                      readings: action.telemetry,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One block of readings, or a note when the backend sent none.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.readings});

  final String title;
  final Map<String, dynamic>? readings;

  /// Keys that repeat what the row already shows, or that mean nothing to a
  /// reader.
  static const Set<String> _hidden = <String>{
    'name',
    'organization',
    'device_id',
    'units_resolved',
  };

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> entries = <String, dynamic>{
      for (final MapEntry<String, dynamic> e in (readings ?? const {}).entries)
        if (!_hidden.contains(e.key)) e.key: e.value,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: context.r(6)),
        Text(
          title,
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: context.sp(12),
            color: AppColors.tealDark,
          ),
        ),
        SizedBox(height: context.r(6)),
        if (entries.isEmpty)
          Text(
            AppStrings.noReadings,
            style: AppTextStyles.helper.copyWith(fontSize: context.sp(11)),
          )
        else
          for (final MapEntry<String, dynamic> e in entries.entries)
            ReadingRow(name: e.key, value: e.value),
        SizedBox(height: context.r(8)),
      ],
    );
  }
}

