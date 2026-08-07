import 'package:flutter/material.dart';

import 'package:fluxa/components/status_card.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/dashboard/dashboard_models.dart';

/// Binds a [SystemStatus] to the presentational [StatusCard].
///
/// All the mapping from state to artwork, palette and copy lives here, so the
/// card itself stays reusable for any reading of this shape.
class SystemStatusCard extends StatelessWidget {
  const SystemStatusCard({super.key, required this.status, this.kilowatts});

  final SystemStatus status;

  /// Null renders a dash rather than inventing a number.
  final double? kilowatts;

  @override
  Widget build(BuildContext context) {
    return StatusCard(
      mascotAsset: status.mascot,
      iconAsset: status.glyph,
      accent: status.accent,
      surface: status.surface,
      valueInk: status.ink,
      label: AppStrings.statusLabel,
      statusWord: status.word,
      value: kilowatts?.toStringAsFixed(1) ?? AppStrings.noReading,
      unit: AppStrings.kilowattSuffix,
      caption: status.caption,
    );
  }
}
