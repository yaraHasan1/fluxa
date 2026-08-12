part of 'login_cubit.dart';

/// View state for the login form.
class LoginState extends Equatable {
  const LoginState({
    this.obscurePassword = true,
    this.status = RequestStatus.idle,
    this.error,
  });

  /// Whether the password field is masked.
  final bool obscurePassword;

  final RequestStatus status;

  /// Set only when [status] is failure.
  final String? error;

  LoginState copyWith({
    bool? obscurePassword,
    RequestStatus? status,
    String? error,
    bool clearError = false,
  }) => LoginState(
    obscurePassword: obscurePassword ?? this.obscurePassword,
    status: status ?? this.status,
    error: clearError ? null : (error ?? this.error),
  );

  /// Shorthand for the failure case, which always carries a message.
  LoginState failed(String message) =>
      copyWith(status: RequestStatus.failure, error: message);

  @override
  List<Object?> get props => <Object?>[obscurePassword, status, error];
}
