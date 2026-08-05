import 'package:flutter/material.dart';

import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// One row in the breakers list: state dot, device glyph, name, priority pill,
/// load and the switch.
class CircuitBreakerTile extends StatelessWidget {
  const CircuitBreakerTile({
    super.key,
    required this.breaker,
    required this.onChanged,
  });

  final CircuitBreaker breaker;
  final ValueChanged<bool>? onChanged;

  /// The pill colour steps down with priority — first is the most critical.
  Color get _priorityColour => switch (breaker.priority) {
    1 => AppColors.statusBad,
    2 => AppColors.statusWarning,
    _ => AppColors.mintDeep,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.r(10)),
      padding: EdgeInsets.symmetric(
        horizontal: context.r(10),
        vertical: context.r(8),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(context.r(14)),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: context.r(7),
            height: context.r(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: breaker.isOn ? _priorityColour : AppColors.shellMid,
            ),
          ),
          SizedBox(width: context.r(8)),

          // PLACEHOLDER: the per-device artwork (monitor, server rack, air
          // conditioner) has not been supplied yet.
          Icon(Icons.devices_other, size: context.r(22), color: AppColors.teal),
          SizedBox(width: context.r(10)),

          Expanded(
            child: Text(
              breaker.name,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.helper.copyWith(
                fontSize: context.sp(12),
                color: AppColors.ink,
              ),
            ),
          ),

          _PriorityPill(priority: breaker.priority, colour: _priorityColour),
          SizedBox(width: context.r(8)),

          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: breaker.kilowatts.toStringAsFixed(1),
                  style: AppTextStyles.reading.copyWith(
                    fontSize: context.sp(13),
                    color: AppColors.teal,
                  ),
                ),
                TextSpan(
                  text: AppStrings.kilowattSuffix,
                  style: AppTextStyles.readingUnit.copyWith(
                    fontSize: context.sp(9),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.r(4)),

          Transform.scale(
            scale: 0.78,
            child: Switch(
              value: breaker.isOn,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.teal,
            ),
          ),
        ],
      ),
    );
  }
}

/// "1st" / "2nd" / "3rd".
class _PriorityPill extends StatelessWidget {
  const _PriorityPill({required this.priority, required this.colour});

  final int priority;
  final Color colour;

  static const List<String> _suffixes = <String>['th', 'st', 'nd', 'rd'];

  String get _label {
    // 11-13 take "th" regardless of last digit.
    final int mod100 = priority % 100;
    if (mod100 >= 11 && mod100 <= 13) return '${priority}th';
    final int last = priority % 10;
    return '$priority${last < _suffixes.length ? _suffixes[last] : 'th'}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.r(10),
        vertical: context.r(3),
      ),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(context.r(8)),
      ),
      child: Text(
        _label,
        style: AppTextStyles.helper.copyWith(
          fontSize: context.sp(10),
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
