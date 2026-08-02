import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_state.dart';

/// Holds the brand frame on screen, then reports that it is done.
///
/// The Cubit owns only the timing. Where to go next is the screen's decision,
/// so this stays free of any routing dependency.
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  static const Duration hold = Duration(milliseconds: 2500);

  Timer? _timer;

  void start() {
    _timer?.cancel();
    _timer = Timer(hold, () {
      if (!isClosed) emit(const SplashComplete());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
