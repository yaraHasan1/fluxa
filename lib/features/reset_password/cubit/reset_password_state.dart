part of 'reset_password_cubit.dart';

/// View state for the new-password frame.
///
/// The two fields mask independently, so a user can reveal one to check it
/// against the other.
class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.obscurePassword = true,
    this.obscureConfirm = true,
  });

  final bool obscurePassword;
  final bool obscureConfirm;

  ResetPasswordState copyWith({bool? obscurePassword, bool? obscureConfirm}) =>
      ResetPasswordState(
        obscurePassword: obscurePassword ?? this.obscurePassword,
        obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      );

  @override
  List<Object?> get props => <Object?>[obscurePassword, obscureConfirm];
}
