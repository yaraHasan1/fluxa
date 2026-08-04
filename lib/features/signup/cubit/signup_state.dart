part of 'signup_cubit.dart';

/// View state for the signup form.
///
/// The two password fields mask independently, so a user can reveal one to
/// check it against the other.
class SignupState extends Equatable {
  const SignupState({this.obscurePassword = true, this.obscureConfirm = true});

  final bool obscurePassword;
  final bool obscureConfirm;

  SignupState copyWith({bool? obscurePassword, bool? obscureConfirm}) =>
      SignupState(
        obscurePassword: obscurePassword ?? this.obscurePassword,
        obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      );

  @override
  List<Object?> get props => <Object?>[obscurePassword, obscureConfirm];
}
