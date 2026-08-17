import 'package:flutter/foundation.dart';

import 'package:fluxa/api/api_client.dart';

/// An organisation as the backend files it.
///
/// Like a registration request, this comes back `pending`: creating one asks
/// for it, and a reviewer decides — which is what the confirmation panel says.
@immutable
class Organisation {
  const Organisation({
    required this.id,
    required this.name,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String phone;

  /// Sent and returned as strings, and kept that way: they are shown, never
  /// calculated with, so parsing them would only risk losing a digit.
  final String latitude;
  final String longitude;

  final String status;
  final DateTime? createdAt;

  bool get isPending => status == 'pending';

  factory Organisation.fromJson(Map<String, dynamic> json) {
    final String? created = json['created_at'] as String?;

    return Organisation(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      status: json['status'] as String? ?? '',
      createdAt: created == null ? null : DateTime.tryParse(created)?.toLocal(),
    );
  }
}

/// Organisation endpoints.
class OrganisationsApi {
  const OrganisationsApi(this._client);

  final ApiClient _client;

  static const String _organisations = '/organizations/';

  /// Files a request for a new organisation. Comes back pending review.
  Future<Organisation> create({
    required String name,
    required String phone,
    required String latitude,
    required String longitude,
  }) async {
    final Map<String, dynamic> json = await _client
        .postForm(_organisations, <String, dynamic>{
          'name': name,
          'phone': phone,
          'latitude': latitude,
          'longitude': longitude,
        });

    return Organisation.fromJson(json);
  }
}
