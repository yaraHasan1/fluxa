import 'package:flutter/foundation.dart';

import 'package:fluxa/features/dashboard/dashboard_models.dart';

/// One line in the history log: what happened, to which circuit, and when.
@immutable
class HistoryEntry {
  const HistoryEntry({
    required this.device,
    required this.circuitName,
    required this.message,
    required this.at,
    required this.turnedOff,
  });

  final BreakerDevice device;
  final String circuitName;
  final String message;
  final DateTime at;

  /// Whether the circuit ended up off, which is what the badge reports.
  final bool turnedOff;
}

/// One alert in the notifications list.
@immutable
class NotificationEntry {
  const NotificationEntry({required this.device, required this.message});

  final BreakerDevice device;
  final String message;
}
