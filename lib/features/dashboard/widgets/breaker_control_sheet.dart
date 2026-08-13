import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/api/breakers_api.dart';
import 'package:fluxa/components/reading_row.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Opens the control panel for one breaker: its readings, and the only switch
/// in the app that can turn it on or off.
///
/// A dialog rather than a route — it is a detail of the row behind it — so the
/// dashboard's cubit is handed in explicitly; a dialog is built off the root
/// navigator and does not inherit the screen's providers.
Future<void> showBreakerControl(
  BuildContext context, {
  required DashboardCubit cubit,
  required String deviceId,
}) {
  // The list rows may carry no telemetry, so the live readings are pulled as
  // the panel opens rather than awaited before it.
  cubit.refreshBreaker(deviceId);

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => BlocProvider<DashboardCubit>.value(
      value: cubit,
      child: _BreakerControlSheet(deviceId: deviceId),
    ),
  );
}

class _BreakerControlSheet extends StatelessWidget {
  const _BreakerControlSheet({required this.deviceId});

  final String deviceId;

  /// Keys the panel already shows in its own chrome, or that mean nothing to a
  /// reader.
  static const Set<String> _hidden = <String>{
    'device_id',
    'name',
    'organization',
    'units_resolved',
    'is_on',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (BuildContext context, DashboardState state) {
        final Breaker? breaker = state.breakerFor(deviceId);
        if (breaker == null) return const SizedBox.shrink();

        final bool busy = state.isSwitching(deviceId);

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
                _Header(breaker: breaker),
                SizedBox(height: context.r(10)),

                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        for (final MapEntry<String, dynamic> e
                            in breaker.raw.entries)
                          if (!_hidden.contains(e.key))
                            ReadingRow(name: e.key, value: e.value),
                      ],
                    ),
                  ),
                ),

                if (state.error != null) ...<Widget>[
                  SizedBox(height: context.r(8)),
                  Text(
                    state.error!,
                    style: AppTextStyles.helper.copyWith(
                      fontSize: context.sp(11),
                      color: AppColors.statusBadDeep,
                    ),
                  ),
                ],

                SizedBox(height: context.r(14)),
                _SwitchAction(
                  breaker: breaker,
                  busy: busy,
                  onPressed: () => context.read<DashboardCubit>().switchBreaker(
                    breaker.deviceId,
                    on: !breaker.isOn,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Glyph, name and the current state, with the close cross.
class _Header extends StatelessWidget {
  const _Header({required this.breaker});

  final Breaker breaker;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(
          BreakerDevice.fromType(breaker.type).icon,
          height: context.r(28),
          fit: BoxFit.contain,
          excludeFromSemantics: true,
        ),
        SizedBox(width: context.r(10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                breaker.name,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: context.sp(16),
                  color: AppColors.teal,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                breaker.online
                    ? breaker.isOn
                          ? AppStrings.breakerIsOn
                          : AppStrings.breakerIsOff
                    : AppStrings.breakerIsOffline,
                style: AppTextStyles.helper.copyWith(
                  fontSize: context.sp(11),
                  color: AppColors.tealDark,
                ),
              ),
            ],
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
    );
  }
}

/// The one control that switches a breaker.
class _SwitchAction extends StatelessWidget {
  const _SwitchAction({
    required this.breaker,
    required this.busy,
    required this.onPressed,
  });

  final Breaker breaker;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Turning off is the consequential direction, so it carries the alarm
    // colour and turning back on carries the brand teal.
    final Color colour = breaker.isOn ? AppColors.statusBad : AppColors.teal;

    return SizedBox(
      height: context.r(44),
      child: FilledButton(
        onPressed: busy || !breaker.online ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colour,
          disabledBackgroundColor: AppColors.shellMid,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.r(12)),
            side: const BorderSide(color: AppColors.ink, width: 0.7),
          ),
        ),
        child: busy
            ? SizedBox(
                width: context.r(18),
                height: context.r(18),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                breaker.isOn
                    ? AppStrings.turnBreakerOff
                    : AppStrings.turnBreakerOn,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: context.sp(13),
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
