import 'package:flutter/foundation.dart';

import 'package:fluxa/api/api_client.dart';

/// One system-wide telemetry sample.
///
/// The body is kept whole in [raw]: the endpoint reports a couple of dozen
/// keys and the backend may add more, so nothing here fixes a list of them.
@immutable
class TelemetryReading {
  const TelemetryReading({required this.raw, required this.takenAt});

  final Map<String, dynamic> raw;
  final DateTime? takenAt;

  /// Every reading is null when the sample did not carry it, so a widget can
  /// say it has no figure rather than print a zero nothing reported.
  double? _number(String key) => switch (raw[key]) {
    final num n => n.toDouble(),
    final String s => double.tryParse(s),
    _ => null,
  };

  /// What the whole system is drawing, in watts — the status card's figure.
  double? get activePowerW => _number('ac_output_active_power_W');

  /// The same, in the kilowatts the card reads out.
  double? get kilowatts {
    final double? watts = activePowerW;
    return watts == null ? null : watts / 1000;
  }

  /// Mains voltage: the "electricity" source.
  double? get gridVoltageV => _number('grid_voltage_V');

  /// What the panels are feeding in: the "solar" source.
  double? get pvInputCurrentA => _number('pv_input_current_A');

  /// The battery's own voltage, and how full it is.
  double? get batteryVoltageV => _number('battery_voltage_V');
  double? get batteryPercent => _number('battery_capacity_percent');

  factory TelemetryReading.fromJson(Map<String, dynamic> json) {
    // `timestamp` is when the inverter took the sample; `received_at` is when
    // the backend logged it. The first is the one that describes the reading.
    final String? taken = json['timestamp'] as String?;

    return TelemetryReading(
      raw: json,
      takenAt: taken == null ? null : DateTime.tryParse(taken)?.toLocal(),
    );
  }
}

/// Telemetry endpoints.
class TelemetryApi {
  const TelemetryApi(this._client);

  final ApiClient _client;

  static const String _readings = '/telemetry/readings/';

  /// The most recent sample, or null when none has been recorded.
  ///
  /// Asks for a single row: the list is paged newest first and the dashboard
  /// only ever shows the latest.
  Future<TelemetryReading?> latest() async {
    final List<dynamic> rows = await _client.getList(
      _readings,
      query: <String, dynamic>{'page_size': 1},
    );

    final Map<String, dynamic>? first = rows
        .whereType<Map<String, dynamic>>()
        .firstOrNull;

    return first == null ? null : TelemetryReading.fromJson(first);
  }
}
