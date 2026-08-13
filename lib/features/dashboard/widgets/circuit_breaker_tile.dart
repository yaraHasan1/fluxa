import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/api/breakers_api.dart';
import 'package:fluxa/components/outlined_rich_text.dart'
    show OutlinedRichText, TextRun;
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// One row in the breakers list: state dot, device glyph, name, priority pill,
/// load and the on/off state — on the teal slab the design uses.
///
/// The row reports; it does not switch. Tapping it opens the control panel,
/// which is the only place a breaker can be turned on or off.
class CircuitBreakerTile extends StatelessWidget {
  const CircuitBreakerTile({
    super.key,
    required this.breaker,
    this.onTap,
    this.busy = false,
  });

  final Breaker breaker;
  final VoidCallback? onTap;

  /// A switch is in flight, so the state shown is not settled yet.
  final bool busy;

  BreakerDevice get _device => BreakerDevice.fromType(breaker.type);

  /// The pill colour steps down with priority — first is the most critical.
  Color get _priorityColour => switch (breaker.priority) {
    1 => AppColors.statusBad,
    2 => AppColors.statusWarning,
    _ => AppColors.mintDeep,
  };

  @override
  Widget build(BuildContext context) {
    // The gap sits outside the ink, so a tap does not light up the space
    // between rows.
    return Padding(
      padding: EdgeInsets.only(bottom: context.r(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.r(16)),
        child: _slab(context),
      ),
    );
  }

  Widget _slab(BuildContext context) {
    return Container(
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
          _DeviceGlyph(device: _device, size: context.r(30)),
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
          SizedBox(width: context.r(8)),

          _StatePill(breaker: breaker, busy: busy),
        ],
      ),
    );
  }
}

/// Reports the breaker's state, and that a switch is still landing.
class _StatePill extends StatelessWidget {
  const _StatePill({required this.breaker, required this.busy});

  final Breaker breaker;
  final bool busy;

  /// An unreachable breaker is called out, because the state beside it is the
  /// last one the backend heard rather than a live reading.
  String get _label => !breaker.online
      ? AppStrings.breakerOffline
      : breaker.isOn
      ? AppStrings.breakerOn
      : AppStrings.breakerOff;

  Color get _colour => !breaker.online
      ? AppColors.shellMid
      : breaker.isOn
      ? AppColors.teal
      : AppColors.shell;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.r(52),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: context.r(4)),
      decoration: BoxDecoration(
        color: _colour,
        borderRadius: BorderRadius.circular(context.r(8)),
        border: Border.all(color: AppColors.ink, width: 0.7),
      ),
      child: busy
          ? SizedBox(
              width: context.r(12),
              height: context.r(12),
              child: const CircularProgressIndicator(
                strokeWidth: 1.8,
                color: AppColors.ink,
              ),
            )
          : Text(
              _label,
              style: AppTextStyles.helper.copyWith(
                fontSize: context.sp(10),
                color: breaker.isOn && breaker.online
                    ? Colors.white
                    : AppColors.ink,
                fontWeight: FontWeight.w700,
              ),
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
    return SvgPicture.asset(
      device.icon,
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
