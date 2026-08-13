import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/api/breakers_api.dart';
import 'package:fluxa/api/request_status.dart';
import 'package:fluxa/components/deep_list_frame.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/history/cubit/history_cubit.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/injector.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The breaker action log, straight from the API.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryCubit>(
      create: (_) => HistoryCubit(sl<BreakersApi>())..load(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (BuildContext context, HistoryState state) => DeepListFrame(
        title: AppStrings.historyTitle,
        children: switch (state.status) {
          RequestStatus.idle ||
          RequestStatus.loading => <Widget>[const _Centred(_Spinner())],
          RequestStatus.failure => <Widget>[
            _Centred(_Note(state.error ?? AppStrings.genericError)),
          ],
          RequestStatus.success when state.entries.isEmpty => <Widget>[
            const _Centred(_Note(AppStrings.historyEmpty)),
          ],
          RequestStatus.success => <Widget>[
            for (final BreakerAction e in state.entries) _HistoryRow(entry: e),
          ],
        },
      ),
    );
  }
}

/// Keeps a single message or spinner centred in the panel.
class _Centred extends StatelessWidget {
  const _Centred(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: context.hp(0.12)),
    child: Center(child: child),
  );
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: context.r(28),
    height: context.r(28),
    child: const CircularProgressIndicator(
      strokeWidth: 2.4,
      color: AppColors.tealDark,
    ),
  );
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: TextAlign.center,
    style: AppTextStyles.helper.copyWith(
      fontSize: context.sp(12),
      color: AppColors.tealDark,
      fontWeight: FontWeight.w600,
    ),
  );
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final BreakerAction entry;

  /// Formatted as the frame writes it: `9:30 12/7/2026`.
  String get _stamp {
    final DateTime? d = entry.at;
    if (d == null) return '';
    final String minute = d.minute.toString().padLeft(2, '0');
    return '${d.hour}:$minute ${d.day}/${d.month}/${d.year}';
  }

  /// The backend leaves `reason` empty on most rows, so the action itself is
  /// what gets described.
  String get _message => entry.reason.isNotEmpty
      ? entry.reason
      : entry.turnedOff
      ? AppStrings.actionSwitchedOff
      : AppStrings.actionSwitchedOn;

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
              // The log does not say what kind of appliance a breaker is, so
              // every row carries the generic device glyph.
              SvgPicture.asset(
                AppAssets.iconPc,
                height: context.r(24),
                fit: BoxFit.contain,
                excludeFromSemantics: true,
              ),
              SizedBox(height: context.r(3)),
              SizedBox(
                width: context.wp(0.16),
                child: Text(
                  entry.breakerName,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.helper.copyWith(
                    fontSize: context.sp(8),
                    color: AppColors.ink,
                  ),
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
                        _message,
                        style: AppTextStyles.helper.copyWith(
                          fontSize: context.sp(10),
                          color: AppColors.teal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      entry.turnedOff
                          ? AppStrings.breakerOff
                          : AppStrings.breakerOn,
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
