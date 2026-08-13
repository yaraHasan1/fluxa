import 'package:flutter/foundation.dart';

/// The JWT pair the login endpoint returns.
@immutable
class AuthTokens {
  const AuthTokens({required this.access, required this.refresh});

  final String access;
  final String refresh;

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
    access: json['access'] as String? ?? '',
    refresh: json['refresh'] as String? ?? '',
  );

  bool get isValid => access.isNotEmpty;
}

/// Holds the signed-in session.
///
/// Kept apart from the endpoint wrappers because [ApiClient] reads the token to
/// sign each request, and those wrappers depend on the client — leaving this
/// alongside them would make the import cycle.
///
/// In memory only for now: persisting it needs secure storage, which is a
/// separate decision. Everything reads the token from here, so adding that
/// later is a change in one class.
class TokenStore extends ChangeNotifier {
  AuthTokens? _tokens;

  AuthTokens? get tokens => _tokens;
  bool get isSignedIn => _tokens?.isValid ?? false;

  void save(AuthTokens tokens) {
    _tokens = tokens;
    notifyListeners();
  }

  void clear() {
    _tokens = null;
    notifyListeners();
  }
}
