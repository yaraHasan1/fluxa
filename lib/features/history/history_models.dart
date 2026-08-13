import 'package:flutter/foundation.dart';

import 'package:fluxa/features/dashboard/dashboard_models.dart';

/// One alert in the notifications list.
///
/// History no longer models anything here — it renders [BreakerAction] from
/// the API directly.
@immutable
class NotificationEntry {
  const NotificationEntry({required this.device, required this.message});

  final BreakerDevice device;
  final String message;
}
