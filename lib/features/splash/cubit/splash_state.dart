part of 'splash_cubit.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => <Object?>[];
}

/// The brand frame is on screen and holding.
final class SplashInitial extends SplashState {
  const SplashInitial();
}

/// The hold has elapsed; the screen should move on.
final class SplashComplete extends SplashState {
  const SplashComplete();
}
