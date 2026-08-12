/// Where a single request has got to.
///
/// Shared by every cubit that talks to the API, so screens can all read the
/// same four cases instead of each feature inventing its own.
enum RequestStatus {
  idle,
  loading,
  success,
  failure;

  bool get isLoading => this == RequestStatus.loading;
  bool get isSuccess => this == RequestStatus.success;
  bool get isFailure => this == RequestStatus.failure;
}
