part of 'login_cubit.dart';

/// View state for the login form.
///
/// Only what the UI genuinely owns lives here. There is no submission state
/// yet — that arrives with the auth backend, not before it.
class LoginState extends Equatable {
  const LoginState({this.obscurePassword = true});

  /// Whether the password field is masked.
  final bool obscurePassword;

  LoginState copyWith({bool? obscurePassword}) =>
      LoginState(obscurePassword: obscurePassword ?? this.obscurePassword);

  @override
  List<Object?> get props => <Object?>[obscurePassword];
}
