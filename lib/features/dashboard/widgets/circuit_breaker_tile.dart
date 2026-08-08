import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/components/status_card.dart'
    show OutlinedRichText, TextRun;
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// One row in the breakers list: state dot, device glyph, name, priority pill,
/// load and the switch — on the teal slab the design uses.
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
      margin: EdgeInsets.only(bottom: context.r(12)),
      padding: EdgeInsets.symmetric(
        horizontal: context.r(12),
        vertical: context.r(10),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            AppColors.mintDeep.withValues(alpha: 0.85),
            AppColors.mint.withValues(alpha: 0.55),
          ],
        ),
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: AppColors.tealBright.withValues(alpha: 0.6)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.glow.withValues(alpha: 0.35),
            blurRadius: context.r(12),
            offset: Offset(0, context.r(4)),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: context.r(8),
            height: context.r(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: breaker.isOn ? _priorityColour : Colors.white,
              border: Border.all(color: AppColors.ink, width: 0.8),
            ),
          ),
          SizedBox(width: context.r(10)),
          _DeviceGlyph(device: breaker.device, size: context.r(30)),
          SizedBox(width: context.r(12)),

          Expanded(
            child: Text(
              breaker.name,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.helper.copyWith(
                fontSize: context.sp(12),
                color: AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          _PriorityPill(priority: breaker.priority, colour: _priorityColour),
          SizedBox(width: context.r(8)),

          OutlinedRichText(
            outline: AppColors.ink,
            strokeWidth: context.r(1.8),
            spans: <TextRun>[
              TextRun(
                breaker.kilowatts.toStringAsFixed(1),
                AppTextStyles.reading.copyWith(
                  fontSize: context.sp(14),
                  color: AppColors.tealDark,
                ),
              ),
              TextRun(
                AppStrings.kilowattSuffix,
                AppTextStyles.readingUnit.copyWith(fontSize: context.sp(9)),
              ),
            ],
          ),
          SizedBox(width: context.r(4)),

          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: breaker.isOn,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.teal,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: AppColors.shellMid,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceGlyph extends StatelessWidget {
  const _DeviceGlyph({required this.device, required this.size});

  final BreakerDevice device;
  final double size;

  @override
  Widget build(BuildContext context) {
    final String? asset = device.icon;

    // PLACEHOLDER: the air-conditioner artwork is still outstanding.
    if (asset == null) {
      return Icon(Icons.ac_unit, size: size * 0.8, color: AppColors.tealDark);
    }

    return SvgPicture.asset(
      asset,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
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
      width: context.r(42),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: context.r(3)),
      decoration: BoxDecoration(
        color: colour,
        borderRadius: BorderRadius.circular(context.r(7)),
        border: Border.all(color: AppColors.ink, width: 0.7),
      ),
      child: Text(
        _label,
        style: AppTextStyles.helper.copyWith(
          fontSize: context.sp(10),
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
