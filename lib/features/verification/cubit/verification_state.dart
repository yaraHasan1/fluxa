part of 'verification_cubit.dart';

/// View state for the code entry frame.
class VerificationState extends Equatable {
  const VerificationState({this.code = '', this.length = 5});

  /// What the user has typed so far; may be shorter than [length].
  final String code;

  /// How many boxes the frame shows.
  final int length;

  /// Whether the code is long enough to submit.
  bool get isComplete => code.length == length;

  VerificationState copyWith({String? code}) =>
      VerificationState(code: code ?? this.code, length: length);

  @override
  List<Object?> get props => <Object?>[code, length];
}
