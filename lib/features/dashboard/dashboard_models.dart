import 'package:flutter/material.dart';

import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/theme/app_colors.dart';

/// Overall health of the system, which drives the whole status card — mascot,
/// glyph, palette and copy.
enum SystemStatus {
  healthy,
  bad,
  warning;

  String get mascot => switch (this) {
    SystemStatus.healthy => AppAssets.fluxaHappy,
    SystemStatus.bad => AppAssets.fluxaAngry,
    SystemStatus.warning => AppAssets.fluxaWarning,
  };

  String get glyph => switch (this) {
    SystemStatus.healthy => AppAssets.iconEnergy,
    SystemStatus.bad => AppAssets.iconFire,
    SystemStatus.warning => AppAssets.iconAlert,
  };

  /// Accent used for the reading, the ring and the card edge.
  Color get accent => switch (this) {
    SystemStatus.healthy => AppColors.statusHealthy,
    SystemStatus.bad => AppColors.statusBad,
    SystemStatus.warning => AppColors.statusWarning,
  };

  /// The card's fill.
  Color get surface => switch (this) {
    SystemStatus.healthy => AppColors.statusHealthySurface,
    SystemStatus.bad => AppColors.statusBadSurface,
    SystemStatus.warning => AppColors.statusWarningSurface,
  };

  /// Colour for the word after "Status:".
  Color get ink => switch (this) {
    SystemStatus.healthy => AppColors.statusHealthy,
    SystemStatus.bad => AppColors.statusBadDeep,
    SystemStatus.warning => AppColors.statusWarningDeep,
  };

  /// The word after "Status:".
  String get word => switch (this) {
    SystemStatus.healthy => AppStrings.statusHealthy,
    SystemStatus.bad => AppStrings.statusBad,
    SystemStatus.warning => AppStrings.statusWarning,
  };

  /// The line under the reading.
  String get caption => switch (this) {
    SystemStatus.healthy => AppStrings.statusHealthyCaption,
    SystemStatus.bad => AppStrings.statusBadCaption,
    SystemStatus.warning => AppStrings.statusWarningCaption,
  };
}

/// Where the power is coming from. The icons are still to be supplied, so the
/// artwork is not referenced here yet.
enum EnergySourceKind { solar, wind, battery }

/// One production line in the "Energy sources" row.
@immutable
class EnergySource {
  const EnergySource({required this.kind, required this.kilowatts});

  final EnergySourceKind kind;
  final double kilowatts;
}

/// One switchable circuit in the breakers list.
@immutable
class CircuitBreaker {
  const CircuitBreaker({
    required this.name,
    required this.priority,
    required this.kilowatts,
    required this.isOn,
  });

  final String name;

  /// 1-based; rendered as the "1st" / "2nd" / "3rd" pill.
  final int priority;

  final double kilowatts;
  final bool isOn;

  CircuitBreaker copyWith({bool? isOn}) => CircuitBreaker(
    name: name,
    priority: priority,
    kilowatts: kilowatts,
    isOn: isOn ?? this.isOn,
  );
}
