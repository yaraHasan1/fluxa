import 'package:flutter/foundation.dart';

import 'package:fluxa/api/api_client.dart';

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
/// In memory only for now: persisting it needs secure storage, which is a
/// separate decision. Everything that needs the token reads it from here, so
/// adding persistence later is a change in one class.
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

/// Authentication endpoints.
class AuthApi {
  const AuthApi(this._client);

  final ApiClient _client;

  static const String _login = '/accounts/login/';

  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> json = await _client.postForm(_login, {
      'email': email,
      'password': password,
    });

    final AuthTokens tokens = AuthTokens.fromJson(json);
    if (!tokens.isValid) {
      throw const ApiException('The server did not return a session token.');
    }
    return tokens;
  }
}
