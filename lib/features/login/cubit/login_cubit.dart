import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

/// Owns the login form's view state.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void togglePasswordVisibility() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
}
