part of 'history_cubit.dart';

/// What the history frame is showing.
class HistoryState extends Equatable {
  const HistoryState({
    this.status = RequestStatus.idle,
    this.entries = const <BreakerAction>[],
    this.error,
  });

  final RequestStatus status;
  final List<BreakerAction> entries;

  /// Set only when [status] is failure.
  final String? error;

  HistoryState copyWith({
    RequestStatus? status,
    List<BreakerAction>? entries,
    String? error,
    bool clearError = false,
  }) => HistoryState(
    status: status ?? this.status,
    entries: entries ?? this.entries,
    error: clearError ? null : (error ?? this.error),
  );

  HistoryState failed(String message) =>
      copyWith(status: RequestStatus.failure, error: message);

  @override
  List<Object?> get props => <Object?>[status, entries, error];
}
