import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxa/features/dashboard/dashboard_models.dart';

part 'dashboard_state.dart';

/// Owns what the dashboard displays.
///
/// Readings are pushed in via [show] because there is no telemetry service to
/// pull them from yet. Toggling a breaker updates the view only — the command
/// has nowhere to go until the backend exists.
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  void show(DashboardState next) => emit(next);

  void toggleBreaker(int index, bool isOn) {
    if (index < 0 || index >= state.breakers.length) return;

    final List<CircuitBreaker> next = List<CircuitBreaker>.of(state.breakers);
    next[index] = next[index].copyWith(isOn: isOn);
    emit(state.copyWith(breakers: next));
  }
}
