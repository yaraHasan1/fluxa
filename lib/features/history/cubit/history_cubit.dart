import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxa/api/api_client.dart';
import 'package:fluxa/api/breakers_api.dart';
import 'package:fluxa/api/request_status.dart';

part 'history_state.dart';

/// Loads the breaker action log.
class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._api) : super(const HistoryState());

  final BreakersApi _api;

  /// [source] narrows the log; the history frame shows manual switches.
  Future<void> load({String? source = 'manual'}) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: RequestStatus.loading, clearError: true));

    try {
      final List<BreakerAction> rows = await _api.actions(source: source);
      emit(state.copyWith(status: RequestStatus.success, entries: rows));
    } on ApiException catch (e) {
      emit(state.failed(e.message));
    }
  }
}
