import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/constants/app_assets.dart';

/// The faint brand watermark that fills an auth frame behind its content.
///
/// [BoxFit.cover] rather than `contain`: the export is 440×956 and the frame it
/// lands on will rarely match that ratio, and letterboxing the watermark would
/// leave a visible seam of flat background at the top or bottom.
class FluxaBackdrop extends StatelessWidget {
  const FluxaBackdrop({super.key, this.alignment = Alignment.center});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: SvgPicture.asset(
          AppAssets.fluxaBackground,
          alignment: alignment,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
