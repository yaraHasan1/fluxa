import 'package:flutter/foundation.dart';

import 'package:fluxa/api/api_client.dart';
import 'package:fluxa/api/token_store.dart';

/// Which kind of account is being asked for.
///
/// The wire values are the backend's, so the UI can rename these freely.
enum AccountRole {
  homeUser('home_user'),
  organisation('organization');

  const AccountRole(this.wire);

  final String wire;
}

/// What the backend returns when an access request is filed.
///
/// It is a *request*, not an account: [status] comes back `pending` until it
/// is reviewed, which is what the "we will send you the approval" panel says.
@immutable
class RegistrationRequest {
  const RegistrationRequest({
    required this.id,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
  });

  final int id;
  final String email;
  final String phone;
  final String role;
  final String status;

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) =>
      RegistrationRequest(
        id: json['id'] as int? ?? 0,
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        role: json['role'] as String? ?? '',
        status: json['status'] as String? ?? '',
      );

  bool get isPending => status == 'pending';
}

/// Authentication endpoints.
class AuthApi {
  const AuthApi(this._client);

  final ApiClient _client;

  static const String _login = '/accounts/login/';
  static const String _requests = '/accounts/requests/';

  /// Files a request for access. Returns it with its pending status.
  Future<RegistrationRequest> register({
    required String email,
    required String phone,
    required AccountRole role,
  }) async {
    final Map<String, dynamic> json = await _client.postForm(_requests, {
      'email': email,
      'phone': phone,
      'role': role.wire,
    });

    return RegistrationRequest.fromJson(json);
  }

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
