import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_state.dart';

/// Owns the signup form's view state.
class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(const SignupState());

  void togglePasswordVisibility() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));

  void toggleConfirmVisibility() =>
      emit(state.copyWith(obscureConfirm: !state.obscureConfirm));
}
