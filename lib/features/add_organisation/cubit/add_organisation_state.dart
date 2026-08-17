part of 'add_organisation_cubit.dart';

/// How filing the organisation is going.
class AddOrganisationState extends Equatable {
  const AddOrganisationState({this.status = RequestStatus.idle, this.error});

  final RequestStatus status;

  /// Set only when [status] is failure.
  final String? error;

  AddOrganisationState copyWith({
    RequestStatus? status,
    String? error,
    bool clearError = false,
  }) => AddOrganisationState(
    status: status ?? this.status,
    error: clearError ? null : (error ?? this.error),
  );

  AddOrganisationState failed(String message) =>
      copyWith(status: RequestStatus.failure, error: message);

  @override
  List<Object?> get props => <Object?>[status, error];
}
