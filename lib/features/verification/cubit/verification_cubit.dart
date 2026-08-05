import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verification_state.dart';

/// Owns the entered code.
///
/// Sending and checking the code belong to the auth backend, so neither the
/// resend action nor submission is modelled here yet.
class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit() : super(const VerificationState());

  void codeChanged(String code) => emit(state.copyWith(code: code));
}
