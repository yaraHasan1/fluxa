import 'package:flutter/foundation.dart';

import 'package:fluxa/api/api_client.dart';

/// One recorded switch of a circuit breaker.
///
/// The endpoint returns far more than the history frame shows — a whole
/// telemetry block per row — so only the fields the UI reads are modelled.
/// Adding one later is a line here, not a new request.
@immutable
class BreakerAction {
  const BreakerAction({
    required this.id,
    required this.breakerName,
    required this.action,
    required this.reason,
    required this.actorEmail,
    required this.confirmed,
    required this.at,
  });

  final int id;
  final String breakerName;

  /// `switch_on` or `switch_off`.
  final String action;

  /// Free text from the backend; usually empty.
  final String reason;

  final String actorEmail;
  final bool confirmed;

  /// When the reading behind the action was taken.
  final DateTime? at;

  /// Whether the circuit ended up off, which is what the row's badge reports.
  bool get turnedOff => action == 'switch_off';

  factory BreakerAction.fromJson(Map<String, dynamic> json) {
    // The timestamp lives inside the telemetry block, not at the top level.
    final Object? telemetry = json['telemetry'];
    final String? stamp = telemetry is Map<String, dynamic>
        ? (telemetry['timestamp'] ?? telemetry['received_at']) as String?
        : null;

    return BreakerAction(
      id: json['id'] as int? ?? 0,
      breakerName: json['breaker_name'] as String? ?? '',
      action: json['action'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      actorEmail: json['actor_email'] as String? ?? '',
      confirmed: json['confirmed'] as bool? ?? false,
      at: stamp == null ? null : DateTime.tryParse(stamp)?.toLocal(),
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
