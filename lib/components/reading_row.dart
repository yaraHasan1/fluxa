import 'package:flutter/material.dart';

import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// A single `icon  label … value unit` line, built straight from a backend key.
///
/// Shared by every panel that renders raw readings, so a `voltage_V` reads the
/// same wherever it is shown.
class ReadingRow extends StatelessWidget {
  const ReadingRow({super.key, required this.name, required this.value});

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

  /// The glyph for this reading, chosen from the key rather than a table of
  /// every field: the backend adds keys, and a new `*_voltage_V` should arrive
  /// already carrying the right icon.
  IconData get _icon {
    final String key = name.toLowerCase();

    if (key.contains('battery') || key.contains('capacity')) {
      return Icons.battery_charging_full;
    }
    if (key.contains('temp')) return Icons.thermostat;
    if (key.contains('freq')) return Icons.graphic_eq;
    if (key.contains('voltage')) return Icons.bolt;
    if (key.contains('current')) return Icons.electric_meter;
    if (key.contains('power') || key.endsWith('_w') || key.endsWith('_va')) {
      return Icons.electrical_services;
    }
    if (key.contains('percent') || key.contains('load')) return Icons.speed;
    if (key.contains('pv') || key.contains('solar')) return Icons.wb_sunny;
    if (key.contains('online')) return Icons.wifi;
    if (key.contains('lock')) return Icons.lock;
    if (key.contains('countdown') || key.contains('timer')) return Icons.timer;
    if (key.contains('fault') || key.contains('alarm')) {
      return Icons.warning_amber;
    }
    if (key.contains('priority')) return Icons.flag;
    if (key.contains('status') || key.contains('flags')) return Icons.info;
    if (key.contains('type')) return Icons.category;
    if (key.contains('time') || key.contains('_at')) return Icons.schedule;

    return Icons.circle;
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
      padding: EdgeInsets.symmetric(vertical: context.r(5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(_icon, size: context.r(18), color: AppColors.mintDeep),
          SizedBox(width: context.r(9)),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.helper.copyWith(
                fontSize: context.sp(13),
                color: AppColors.ink,
              ),
            ),
          ),
          SizedBox(width: context.r(8)),
          Text(
            unit.isEmpty ? _value : '$_value $unit',
            style: AppTextStyles.helper.copyWith(
              fontSize: context.sp(14),
              color: AppColors.teal,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
