import 'package:flutter/material.dart';

import 'package:fluxa/api/breakers_api.dart';
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
            _ReadingRow(name: e.key, value: e.value),
        SizedBox(height: context.r(8)),
      ],
    );
  }
}

/// A single `label … value unit` line.
class _ReadingRow extends StatelessWidget {
  const _ReadingRow({required this.name, required this.value});

  final String name;
  final dynamic value;

  /// Trailing key fragments the backend uses as units.
  static const Map<String, String> _units = <String, String>{
    'V': 'V',
    'A': 'A',
    'W': 'W',
    'VA': 'VA',
    'Hz': 'Hz',
    'C': '°C',
    's': 's',
    'percent': '%',
  };

  /// `battery_voltage_V` becomes ("Battery voltage", "V").
  (String, String) get _labelAndUnit {
    final List<String> parts = name.split('_');
    String unit = '';

    if (parts.length > 1 && _units.containsKey(parts.last)) {
      unit = _units[parts.removeLast()]!;
    }

    final String label = parts.join(' ');
    return (
      label.isEmpty ? name : label[0].toUpperCase() + label.substring(1),
      unit,
    );
  }

  /// Booleans read better as words than as `true`.
  String get _value => switch (value) {
    final bool b => b ? AppStrings.yes : AppStrings.no,
    null => '—',
    _ => '$value',
  };

  @override
  Widget build(BuildContext context) {
    final (String label, String unit) = _labelAndUnit;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.r(3)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.helper.copyWith(
                fontSize: context.sp(11),
                color: AppColors.ink,
              ),
            ),
          ),
          SizedBox(width: context.r(8)),
          Text(
            unit.isEmpty ? _value : '$_value $unit',
            style: AppTextStyles.helper.copyWith(
              fontSize: context.sp(11),
              color: AppColors.teal,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
