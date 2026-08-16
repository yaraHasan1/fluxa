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

/// Where the power is coming from.
///
/// [grid] was named `wind` while the screen ran on stand-in figures; the glyph
/// has always been a pylon, and the reading behind it is mains voltage.
enum EnergySourceKind {
  solar,
  grid,
  battery;

  String get icon => switch (this) {
    EnergySourceKind.solar => AppAssets.iconSolar,
    EnergySourceKind.grid => AppAssets.iconWind,
    EnergySourceKind.battery => AppAssets.iconBattery,
  };

  /// The line under the figure on the expanded card. Each source reports a
  /// different quantity, so each says which one.
  String get productionCaption => switch (this) {
    EnergySourceKind.solar => AppStrings.solarCaption,
    EnergySourceKind.grid => AppStrings.gridCaption,
    EnergySourceKind.battery => AppStrings.batteryCaption,
  };

  /// Colour of this column's reading, matching the icon it sits under.
  Color get accent => switch (this) {
    EnergySourceKind.solar => AppColors.statusWarning,
    EnergySourceKind.grid => AppColors.windBlue,
    EnergySourceKind.battery => AppColors.teal,
  };
}

/// The appliance a breaker controls.
enum BreakerDevice {
  pc,
  server,
  airConditioner;

  String get icon => switch (this) {
    BreakerDevice.pc => AppAssets.iconPc,
    BreakerDevice.server => AppAssets.iconServer,
    BreakerDevice.airConditioner => AppAssets.iconAc,
  };

  /// Maps the backend's `type` onto the three glyphs the design ships.
  ///
  /// The backend does not publish its list of types, so this matches the ones
  /// seen so far and falls back to [pc] — a wrong glyph is better than none.
  static BreakerDevice fromType(String type) => switch (type.toLowerCase()) {
    'server' || 'rack' || 'nas' => server,
    'motor' || 'ac' || 'air_conditioner' || 'hvac' || 'heater' =>
      airConditioner,
    _ => pc,
  };
}

/// One production line in the "Energy sources" row.
@immutable
class EnergySource {
  const EnergySource({
    required this.kind,
    required this.value,
    required this.unit,
    this.chargePercent,
  });

  final EnergySourceKind kind;

  /// The figure itself, or null when telemetry has not reported it.
  final double? value;

  /// What [value] is measured in — volts for the grid, amps for the panels.
  /// The three sources no longer share a unit, so each carries its own.
  final String unit;

  /// Charge level, shown as a pill on the expanded card. Only the battery has
  /// one; the others leave it null rather than render an empty badge.
  final int? chargePercent;
}

