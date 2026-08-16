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

/// One circuit breaker, as the list and status endpoints report it.
///
/// [raw] keeps the whole body: the readings panel renders whatever the backend
/// sent rather than a fixed list, exactly as the history sheet does, so a new
/// telemetry field needs no change here.
@immutable
class Breaker {
  const Breaker({
    required this.deviceId,
    required this.name,
    required this.type,
    required this.priority,
    required this.priorityType,
    required this.isOn,
    required this.online,
    required this.raw,
    this.powerW,
  });

  final String deviceId;
  final String name;

  /// The appliance kind, e.g. `motor`. Drives which glyph the row shows.
  final String type;

  /// 1-based; rendered as the "1st" / "2nd" / "3rd" pill.
  final int priority;

  /// `mandatory` and whatever else the backend records.
  final String priorityType;

  /// Null when the endpoint said nothing about it — the list endpoint carries
  /// only what is stored, so live state arrives from `status/` instead. Never
  /// read this as "off": a missing answer is not a state.
  final bool? isOn;

  /// Whether the device is reachable, or null when unreported. An unreachable
  /// breaker still reports its last known [isOn].
  final bool? online;

  /// Live load. Null when the endpoint sent no reading.
  final double? powerW;

  /// Whether this row knows the breaker's actual state, or is just the stored
  /// record and needs a `status/` read behind it.
  bool get hasLiveState => isOn != null;

  final Map<String, dynamic> raw;

  /// Load in kW, the unit the dashboard reads in.
  double get kilowatts => (powerW ?? 0) / 1000;

  static double? _toDouble(Object? value) => switch (value) {
    final num n => n.toDouble(),
    final String s => double.tryParse(s),
    _ => null,
  };

  factory Breaker.fromJson(Map<String, dynamic> json) => Breaker(
    // The list endpoint may key the id either way.
    deviceId: (json['device_id'] ?? json['id'] ?? '').toString(),
    name: json['name'] as String? ?? '',
    type: json['type'] as String? ?? '',
    priority: json['priority'] as int? ?? 0,
    // The backend spells this "priorty_type"; a fix there must not break here.
    priorityType:
        json['priorty_type'] as String? ?? json['priority_type'] as String? ?? '',
    isOn: json['is_on'] as bool?,
    online: json['online'] as bool?,
    powerW: _toDouble(json['power_W']),
    raw: json,
  );
}

/// What the switch endpoint answers with.
///
/// The command is only *queued* when it replies: [confirmed] is false until the
/// device reports back, and [breaker] still carries the pre-switch state. So a
/// switch is followed by a re-read rather than trusted outright.
@immutable
class SwitchOutcome {
  const SwitchOutcome({
    required this.requestedOn,
    required this.confirmed,
    this.breaker,
  });

  final bool requestedOn;
  final bool confirmed;

  /// The status block returned alongside, when there was one.
  final Breaker? breaker;

  factory SwitchOutcome.fromJson(Map<String, dynamic> json) {
    final Object? status = json['status'];

    return SwitchOutcome(
      requestedOn: (json['requested'] as String?) != 'off',
      confirmed: json['confirmed'] as bool? ?? false,
      breaker: status is Map<String, dynamic>
          ? Breaker.fromJson(status)
          : null,
    );
  }
}

/// Circuit-breaker endpoints.
class BreakersApi {
  const BreakersApi(this._client);

  final ApiClient _client;

  static const String _breakers = '/breakers/';
  static const String _actions = '/breakers/actions/';

  /// Every breaker on the account.
  Future<List<Breaker>> list() async {
    final List<dynamic> rows = await _client.getList(_breakers);

    return rows.whereType<Map<String, dynamic>>().map(Breaker.fromJson).toList();
  }

  /// One breaker with its live readings.
  Future<Breaker> status(String deviceId) async =>
      Breaker.fromJson(await _client.getMap('$_breakers$deviceId/status/'));

  /// Asks the device to switch. See [SwitchOutcome] on why the answer is not
  /// the final word.
  Future<SwitchOutcome> switchTo(String deviceId, {required bool on}) async {
    final Map<String, dynamic> json = await _client.postForm(
      '$_breakers$deviceId/switch/',
      <String, dynamic>{'state': on ? 'on' : 'off'},
    );

    return SwitchOutcome.fromJson(json);
  }

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
