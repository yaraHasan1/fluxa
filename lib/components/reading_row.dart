import 'package:flutter/material.dart';

import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// A single `label … value unit` line, built straight from a backend key.
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
