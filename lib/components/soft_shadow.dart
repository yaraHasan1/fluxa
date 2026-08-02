import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Casts a soft glow behind an arbitrary child silhouette.
///
/// The Figma artwork carries its depth in `<filter>` drop shadows, and
/// `flutter_svg` discards every one of them — which leaves the mascot's
/// near-white chassis with no edge against the pale background. Painting the
/// child once as a blurred, offset silhouette restores that separation.
///
/// The default colour is [AppColors.glow], the mint the design's own filters
/// are tinted with; this reads as a halo rather than a grey shadow.
///
/// Recovers the *outer* shadow only. Per-part shadows inside the artwork are
/// still absent; a raster export is the way to get those.
class SoftShadow extends StatelessWidget {
  const SoftShadow({
    super.key,
    required this.child,
    this.color = const Color(0x8074B9AA),
    this.blur = 12,
    this.offset = const Offset(0, 4),
  });

  final Widget child;
  final Color color;
  final double blur;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Transform.translate(
          offset: offset,
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(
              sigmaX: blur,
              sigmaY: blur,
              tileMode: TileMode.decal,
            ),
            child: ColorFiltered(
              // Flattens the child to a single translucent silhouette.
              colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
              child: child,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
