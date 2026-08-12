import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/components/deep_list_frame.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';
import 'package:fluxa/features/history/history_models.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The alert list.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key, this.entries});

  /// Supplied by the caller. Falls back to the frame's stand-in rows until
  /// push messages are wired up.
  final List<NotificationEntry>? entries;

  /// TEMPORARY: the frame repeats one alert; delete once messages are real.
  static const List<NotificationEntry> _placeholder = <NotificationEntry>[
    NotificationEntry(
      device: BreakerDevice.airConditioner,
      message: AppStrings.notificationSample,
    ),
    NotificationEntry(
      device: BreakerDevice.airConditioner,
      message: AppStrings.notificationSample,
    ),
    NotificationEntry(
      device: BreakerDevice.airConditioner,
      message: AppStrings.notificationSample,
    ),
    NotificationEntry(
      device: BreakerDevice.airConditioner,
      message: AppStrings.notificationSample,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<NotificationEntry> items = entries ?? _placeholder;

    return DeepListFrame(
      title: AppStrings.notificationsTitle,
      children: <Widget>[
        for (final NotificationEntry e in items) _NotificationRow(entry: e),
      ],
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.entry});

  final NotificationEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.r(12),
        vertical: context.r(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.mint.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(context.r(12)),
        border: Border.all(color: AppColors.tealBright.withValues(alpha: 0.7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Text(
              entry.message,
              style: AppTextStyles.helper.copyWith(
                fontSize: context.sp(11),
                color: AppColors.ink,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
          SizedBox(width: context.r(8)),
          SvgPicture.asset(
            entry.device.icon,
            height: context.r(22),
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
        ],
      ),
    );
  }
}
