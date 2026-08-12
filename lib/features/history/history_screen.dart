import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/components/deep_list_frame.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';
import 'package:fluxa/features/history/history_models.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The event log.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, this.entries});

  /// Supplied by the caller. Falls back to the frame's stand-in rows until the
  /// backend can list real events.
  final List<HistoryEntry>? entries;

  /// TEMPORARY: the frame repeats one row; delete once events are real.
  static final List<HistoryEntry> _placeholder = List<HistoryEntry>.generate(
    7,
    (_) => HistoryEntry(
      device: BreakerDevice.pc,
      circuitName: 'office pcs',
      message: AppStrings.historySample,
      at: DateTime(2026, 7, 12, 9, 30),
      turnedOff: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final List<HistoryEntry> items = entries ?? _placeholder;

    return DeepListFrame(
      title: AppStrings.historyTitle,
      children: <Widget>[
        for (final HistoryEntry e in items) _HistoryRow(entry: e),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final HistoryEntry entry;

  /// Formatted as the frame writes it: `9:30 12/7/2026`.
  String get _stamp {
    final DateTime d = entry.at;
    final String minute = d.minute.toString().padLeft(2, '0');
    return '${d.hour}:$minute ${d.day}/${d.month}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.r(10),
        vertical: context.r(8),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(context.r(12)),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                entry.device.icon,
                height: context.r(24),
                fit: BoxFit.contain,
                excludeFromSemantics: true,
              ),
              SizedBox(height: context.r(3)),
              Text(
                entry.circuitName,
                style: AppTextStyles.helper.copyWith(
                  fontSize: context.sp(8),
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          SizedBox(width: context.r(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        entry.message,
                        style: AppTextStyles.helper.copyWith(
                          fontSize: context.sp(10),
                          color: AppColors.teal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (entry.turnedOff)
                      Text(
                        AppStrings.breakerOff,
                        style: AppTextStyles.helper.copyWith(
                          fontSize: context.sp(10),
                          color: AppColors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: context.r(6)),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _stamp,
                    style: AppTextStyles.helper.copyWith(
                      fontSize: context.sp(7.5),
                      color: AppColors.shellDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
