import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxa/api/api_client.dart';
import 'package:fluxa/api/breakers_api.dart';
import 'package:fluxa/api/request_status.dart';
import 'package:fluxa/api/telemetry_api.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';

part 'dashboard_state.dart';

/// Owns what the dashboard displays.
///
/// The breaker list is fetched and switched through [BreakersApi]. Consumption
/// and the energy sources are still pushed in via [show], because there is no
/// telemetry service to pull them from yet.
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._api, this._telemetry)
    : super(DashboardState.placeholder());

  final BreakersApi _api;
  final TelemetryApi _telemetry;

  /// How long to wait before re-reading a switch the device had not confirmed.
  /// The endpoint answers as soon as the command is queued, so the status it
  /// returns is still the old one.
  static const Duration _confirmDelay = Duration(seconds: 3);

  /// How often the screen re-reads itself. A breaker can be switched at the
  /// panel, or by the system itself, and nothing tells the app when that
  /// happens — so it asks.
  static const Duration _pollEvery = Duration(seconds: 20);

  Timer? _poll;

  void show(DashboardState next) => emit(next);

  /// Everything the screen shows, read again.
  Future<void> refresh() async {
    await Future.wait(<Future<void>>[load(), loadTelemetry()]);
  }

  /// Starts the periodic re-read. Idempotent, so a rebuild does not stack
  /// timers.
  void startAutoRefresh() {
    _poll ??= Timer.periodic(_pollEvery, (_) => refresh());
  }

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

      await _fillLiveState(rows);
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

  /// Reads the newest telemetry sample into the status card and the three
  /// source cards.
  ///
  /// Its own request, and its own silence on failure: the breaker list is the
  /// screen's substance, and a missing reading must not take it down with it.
  /// The cards show "no reading" instead.
  Future<void> loadTelemetry() async {
    try {
      final TelemetryReading? reading = await _telemetry.latest();
      if (isClosed) return;
      emit(
        state.withTelemetry(
          consumptionKw: reading?.kilowatts,
          sources: _sourcesFrom(reading),
        ),
      );
    } on ApiException {
      if (isClosed) return;
      emit(
        state.withTelemetry(
          consumptionKw: null,
          sources: _sourcesFrom(null),
        ),
      );
    }
  }

  /// The three source cards, each reading a different figure off the sample.
  static List<EnergySource> _sourcesFrom(TelemetryReading? reading) =>
      <EnergySource>[
        EnergySource(
          kind: EnergySourceKind.solar,
          value: reading?.pvInputCurrentA,
          unit: AppStrings.unitAmp,
        ),
        EnergySource(
          kind: EnergySourceKind.grid,
          value: reading?.gridVoltageV,
          unit: AppStrings.unitVolt,
        ),
        EnergySource(
          kind: EnergySourceKind.battery,
          value: reading?.batteryVoltageV,
          unit: AppStrings.unitVolt,
          chargePercent: reading?.batteryPercent?.round(),
        ),
      ];

  /// Reads `status/` for every row the list left without live state.
  ///
  /// The list endpoint returns the stored record — name, type, priority — and
  /// says nothing about whether a breaker is on or reachable. Without this the
  /// rows would all render as an unknown state.
  Future<void> _fillLiveState(List<Breaker> rows) async {
    final List<String> pending = <String>[
      for (final Breaker b in rows)
        if (!b.hasLiveState && b.deviceId.isNotEmpty) b.deviceId,
    ];
    if (pending.isEmpty) return;

    await Future.wait(
      pending.map((String id) => refreshBreaker(id, quiet: true)),
    );
  }

  /// Re-reads one breaker's live state, leaving the rest of the list alone.
  ///
  /// [quiet] drops the failure rather than showing it: when a whole list is
  /// being filled in, one unreachable device must not put an error over the
  /// rows that did load.
  Future<void> refreshBreaker(String deviceId, {bool quiet = false}) async {
    try {
      final Breaker fresh = await _api.status(deviceId);
      if (isClosed) return;
      emit(_withBreaker(fresh));
    } on ApiException catch (e) {
      if (isClosed || quiet) return;
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

  @override
  Future<void> close() {
    _poll?.cancel();
    return super.close();
  }
}
