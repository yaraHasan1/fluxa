import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxa/api/api_client.dart';
import 'package:fluxa/api/breakers_api.dart';
import 'package:fluxa/api/request_status.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';

part 'dashboard_state.dart';

/// Owns what the dashboard displays.
///
/// The breaker list is fetched and switched through [BreakersApi]. Consumption
/// and the energy sources are still pushed in via [show], because there is no
/// telemetry service to pull them from yet.
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._api) : super(DashboardState.placeholder());

  final BreakersApi _api;

  /// How long to wait before re-reading a switch the device had not confirmed.
  /// The endpoint answers as soon as the command is queued, so the status it
  /// returns is still the old one.
  static const Duration _confirmDelay = Duration(seconds: 3);

  void show(DashboardState next) => emit(next);

  void toggleSources() =>
      emit(state.copyWith(sourcesExpanded: !state.sourcesExpanded));

  /// Loads every breaker on the account.
  Future<void> load() async {
    if (state.breakersStatus.isLoading) return;
    emit(state.copyWith(breakersStatus: RequestStatus.loading, clearError: true));

    try {
      final List<Breaker> rows = await _api.list();
      if (isClosed) return;
      emit(
        state.copyWith(breakersStatus: RequestStatus.success, breakers: rows),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(breakersStatus: RequestStatus.failure, error: e.message),
      );
    }
  }

  /// Switches one breaker, then re-reads it if the device had not confirmed.
  Future<void> switchBreaker(String deviceId, {required bool on}) async {
    if (state.isSwitching(deviceId)) return;
    emit(
      state.copyWith(
        switching: <String>{...state.switching, deviceId},
        clearError: true,
      ),
    );

    try {
      final SwitchOutcome outcome = await _api.switchTo(deviceId, on: on);
      if (isClosed) return;

      emit(
        _withBreaker(outcome.breaker).copyWith(switching: _without(deviceId)),
      );

      if (!outcome.confirmed) {
        await Future<void>.delayed(_confirmDelay);
        if (isClosed) return;
        await refreshBreaker(deviceId);
      }
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(error: e.message, switching: _without(deviceId)));
    }
  }

  /// Re-reads one breaker's live state, leaving the rest of the list alone.
  Future<void> refreshBreaker(String deviceId) async {
    try {
      final Breaker fresh = await _api.status(deviceId);
      if (isClosed) return;
      emit(_withBreaker(fresh));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(error: e.message));
    }
  }

  /// Replaces the matching row, keeping the list's order. A [breaker] that is
  /// null, or not in the list, leaves the state untouched.
  DashboardState _withBreaker(Breaker? breaker) {
    if (breaker == null) return state;

    final List<Breaker> next = <Breaker>[
      for (final Breaker b in state.breakers)
        b.deviceId == breaker.deviceId ? breaker : b,
    ];

    return state.copyWith(breakers: next);
  }

  Set<String> _without(String deviceId) =>
      <String>{...state.switching}..remove(deviceId);
}
