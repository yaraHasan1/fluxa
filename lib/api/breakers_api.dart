import 'package:flutter/foundation.dart';

import 'package:fluxa/api/api_client.dart';

/// One recorded switch of a circuit breaker.
///
/// The reading blocks are kept as raw maps on purpose. They carry two dozen
/// keys that the backend may add to, and the readings sheet renders whatever
/// is there rather than a fixed list — so a new field needs no change here.
@immutable
class BreakerAction {
  const BreakerAction({
    required this.id,
    required this.breakerName,
    required this.action,
    required this.source,
    required this.reason,
    required this.actorEmail,
    required this.confirmed,
    required this.createdAt,
    this.telemetry,
    this.breakerStatus,
  });

  final int id;
  final String breakerName;

  /// `switch_on` or `switch_off`.
  final String action;

  /// `manual`, and whatever else the backend records.
  final String source;

  /// Free text from the backend; empty on every row so far.
  final String reason;

  final String actorEmail;
  final bool confirmed;

  /// When the switch was recorded. This is the action's own time — the one
  /// inside [telemetry] is when the *reading* was taken, and is identical
  /// across rows, so it is the wrong thing to show in a log.
  final DateTime? createdAt;

  /// Null on older rows, which predate telemetry capture.
  final Map<String, dynamic>? telemetry;

  /// The breaker's own state at the time.
  final Map<String, dynamic>? breakerStatus;

  /// Whether the circuit ended up off, which is what the row's badge reports.
  bool get turnedOff => action == 'switch_off';

  bool get hasReadings =>
      (telemetry?.isNotEmpty ?? false) || (breakerStatus?.isNotEmpty ?? false);

  factory BreakerAction.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? block(String key) {
      final Object? value = json[key];
      return value is Map<String, dynamic> ? value : null;
    }

    final String? created = json['created_at'] as String?;

    return BreakerAction(
      id: json['id'] as int? ?? 0,
      breakerName: json['breaker_name'] as String? ?? '',
      action: json['action'] as String? ?? '',
      source: json['source'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      actorEmail: json['actor_email'] as String? ?? '',
      confirmed: json['confirmed'] as bool? ?? false,
      createdAt: created == null ? null : DateTime.tryParse(created)?.toLocal(),
      telemetry: block('telemetry'),
      breakerStatus: block('breaker_status'),
    );
  }
}

/// Circuit-breaker endpoints.
class BreakersApi {
  const BreakersApi(this._client);

  final ApiClient _client;

  static const String _actions = '/breakers/actions/';

  /// The action log. [source] filters to `manual` switches, and so on.
  Future<List<BreakerAction>> actions({String? source}) async {
    final List<dynamic> rows = await _client.getList(
      _actions,
      query: source == null ? null : <String, dynamic>{'source': source},
    );

    return rows
        .whereType<Map<String, dynamic>>()
        .map(BreakerAction.fromJson)
        .toList();
  }
}
