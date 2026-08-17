import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// A map you tap to place a pin.
///
/// Tiles come from OpenStreetMap, which needs no API key — the alternative
/// would put a key in the repository and a billing account behind the form.
/// The attribution below the map is that licence's one condition.
///
/// Controlled: the picked [point] is owned by the caller, so the form holds
/// one source of truth for what will be sent.
class LocationPicker extends StatelessWidget {
  const LocationPicker({
    super.key,
    required this.point,
    required this.onPicked,
  });

  /// Null until the user has tapped.
  final LatLng? point;

  final ValueChanged<LatLng> onPicked;

  /// Opens on the whole world rather than guessing at a country. Change these
  /// two to open somewhere in particular.
  static const LatLng _initialCentre = LatLng(20, 0);
  static const double _initialZoom = 1.4;

  /// Zoom applied once a pin exists, so the tapped spot is legible.
  static const double _pickedZoom = 13;

  @override
  Widget build(BuildContext context) {
    final LatLng? picked = point;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(context.r(16)),
          child: SizedBox(
            height: context.hp(0.22),
            child: Stack(
              children: <Widget>[
                FlutterMap(
                  options: MapOptions(
                    initialCenter: picked ?? _initialCentre,
                    initialZoom: picked == null ? _initialZoom : _pickedZoom,
                    onTap: (TapPosition _, LatLng tapped) => onPicked(tapped),
                  ),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.fluxa',
                    ),
                    if (picked != null)
                      MarkerLayer(
                        markers: <Marker>[
                          Marker(
                            point: picked,
                            width: context.r(40),
                            height: context.r(40),
                            alignment: Alignment.topCenter,
                            child: Icon(
                              Icons.location_pin,
                              size: context.r(36),
                              color: AppColors.statusBad,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                Positioned(
                  right: 0,
                  bottom: 0,
                  child: ColoredBox(
                    color: Colors.white70,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.r(4),
                        vertical: context.r(1),
                      ),
                      child: Text(
                        AppStrings.mapAttribution,
                        style: AppTextStyles.helper.copyWith(
                          fontSize: context.sp(8),
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: context.r(6)),

        // What will actually be sent, so the pin is not the only evidence.
        Text(
          picked == null
              ? AppStrings.organisationLocationHint
              : '${picked.latitude.toStringAsFixed(6)}, '
                    '${picked.longitude.toStringAsFixed(6)}',
          style: AppTextStyles.helper.copyWith(
            fontSize: context.sp(12),
            color: picked == null ? AppColors.shellDark : AppColors.teal,
            fontWeight: picked == null ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
