import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxa/api/api_client.dart';
import 'package:fluxa/api/auth_api.dart';
import 'package:fluxa/api/token_store.dart';
import 'package:fluxa/api/request_status.dart';

part 'login_state.dart';

/// Owns the login form: what is masked, and how the sign-in request is going.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._auth, this._tokens) : super(const LoginState());

  final AuthApi _auth;
  final TokenStore _tokens;

  void togglePasswordVisibility() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));

  Future<void> signIn({required String email, required String password}) async {
    if (state.status.isLoading) return;

    // Caught here rather than at the server so an obvious slip costs no round
    // trip; anything subtler is the backend's call, not ours.
    if (email.trim().isEmpty || password.isEmpty) {
      emit(state.failed('Enter your email and password.'));
      return;
    }

    emit(state.copyWith(status: RequestStatus.loading, clearError: true));

    try {
      final AuthTokens tokens = await _auth.login(
        email: email.trim(),
        password: password,
      );
      _tokens.save(tokens);
      emit(state.copyWith(status: RequestStatus.success));
    } on ApiException catch (e) {
      emit(state.failed(e.message));
    }
  }
}
