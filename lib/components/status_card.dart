import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The reading card: a mascot on the left, the status and value in the middle,
/// and a ringed glyph on the right.
///
/// Purely presentational — every asset and colour is passed in, so a caller
/// supplies whichever artwork its state calls for. It knows nothing about
/// system health, which keeps it reusable for any card of this shape.
class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.mascotAsset,
    required this.iconAsset,
    required this.accent,
    required this.surface,
    required this.valueInk,
    required this.label,
    required this.statusWord,
    required this.value,
    required this.unit,
    required this.caption,
    this.ringAsset,
    this.badge,
    this.outline = AppColors.ink,
  });

  /// Robot artwork for this state.
  final String mascotAsset;

  /// Glyph shown inside the ring.
  final String iconAsset;

  /// Supply to use artwork for the ring instead of drawing it. The glyph is
  /// still laid over it, so the export should be the ring alone.
  final String? ringAsset;

  /// Ring and border colour.
  final Color accent;

  /// Card fill.
  final Color surface;

  /// Colour of the status word and the reading.
  final Color valueInk;

  /// Drawn behind the status word and the reading to give the lettering the
  /// hard edge the design has. Set transparent to switch it off.
  final Color outline;

  /// The run before [statusWord], e.g. "Status: ".
  final String label;
  final String statusWord;

  /// Already formatted; the card does no rounding of its own.
  final String value;
  final String unit;
  final String caption;

  /// Optional mark in the top-right corner.
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final Widget card = Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(context.r(18)),
        border: Border.all(color: accent, width: 1.4),
        boxShadow: <BoxShadow>[
          // Wide, brand-tinted lift, then a tight contact shadow directly
          // under the card — the same pair the Figma filters use.
          BoxShadow(
            color: AppColors.glow.withValues(alpha: 0.45),
            blurRadius: context.r(18),
            offset: Offset(0, context.r(6)),
          ),
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.10),
            blurRadius: context.r(4),
            offset: Offset(0, context.r(2)),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.r(8),
          context.r(12),
          context.r(14),
          context.r(12),
        ),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              mascotAsset,
              width: context.wp(0.23),
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
            SizedBox(width: context.r(8)),
            Expanded(child: _readout(context)),
            SizedBox(width: context.r(8)),
            _RingedGlyph(
              iconAsset: iconAsset,
              ringAsset: ringAsset,
              accent: accent,
              diameter: context.r(62),
            ),
          ],
        ),
      ),
    );

    if (badge == null) return card;

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        card,
        Positioned(top: context.r(8), right: context.r(10), child: badge!),
      ],
    );
  }

  Widget _readout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OutlinedRichText(
          outline: outline,
          strokeWidth: context.r(2.2),
          spans: <TextRun>[
            TextRun(
              label,
              AppTextStyles.fieldLabel.copyWith(fontSize: context.sp(15)),
            ),
            TextRun(
              statusWord,
              AppTextStyles.fieldLabel.copyWith(
                fontSize: context.sp(15),
                color: valueInk,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        SizedBox(height: context.r(2)),
        OutlinedRichText(
          outline: outline,
          strokeWidth: context.r(3),
          spans: <TextRun>[
            TextRun(
              value,
              AppTextStyles.reading.copyWith(
                fontSize: context.sp(30),
                color: valueInk,
              ),
            ),
            TextRun(
              unit,
              AppTextStyles.readingUnit.copyWith(fontSize: context.sp(14)),
            ),
          ],
        ),
        SizedBox(height: context.r(4)),
        Text(
          caption,
          style: AppTextStyles.helper.copyWith(fontSize: context.sp(10.5)),
        ),
      ],
    );
  }
}

/// One styled run inside [OutlinedRichText].
class TextRun {
  const TextRun(this.text, this.style);

  final String text;
  final TextStyle style;
}

/// Rich text with a stroked edge behind the fill.
///
/// Flutter cannot stroke and fill a glyph in one pass — `TextStyle.foreground`
/// replaces the fill — so the line is painted twice: once as an outline, then
/// the normal text exactly on top.
class OutlinedRichText extends StatelessWidget {
  const OutlinedRichText({
    super.key,
    required this.spans,
    required this.outline,
    required this.strokeWidth,
  });

  final List<TextRun> spans;
  final Color outline;
  final double strokeWidth;

  TextSpan _build({required bool stroked}) => TextSpan(
    children: <InlineSpan>[
      for (final TextRun run in spans)
        TextSpan(
          text: run.text,
          style: stroked
              // `color` and `foreground` are mutually exclusive, so the stroke
              // copy drops the colour entirely.
              ? run.style.copyWith(
                  color: null,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = strokeWidth
                    ..strokeJoin = StrokeJoin.round
                    ..color = outline,
                )
              : run.style,
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    if (outline.a == 0) return Text.rich(_build(stroked: false));

    return Stack(
      children: <Widget>[
        Text.rich(_build(stroked: true)),
        Text.rich(_build(stroked: false)),
      ],
    );
  }
}

/// The glyph inside its ring.
///
/// The glyph exports differ wildly in shape — the exclamation is 11×59, the
/// flame nearly square — so it is constrained by height and centred rather
/// than stretched to fill the circle.
class _RingedGlyph extends StatelessWidget {
  const _RingedGlyph({
    required this.iconAsset,
    required this.ringAsset,
    required this.accent,
    required this.diameter,
  });

  final String iconAsset;
  final String? ringAsset;
  final Color accent;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (ringAsset != null)
            SvgPicture.asset(
              ringAsset!,
              width: diameter,
              height: diameter,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            )
          else
            CustomPaint(
              size: Size.square(diameter),
              painter: _RingPainter(
                colour: accent,
                strokeWidth: diameter * 0.085,
              ),
            ),
          SvgPicture.asset(
            iconAsset,
            height: diameter * 0.46,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
        ],
      ),
    );
  }
}

/// Draws the ring as a single unbroken stroked circle.
///
/// A `BoxDecoration` border is drawn side by side and can leave a hairline
/// seam where the arcs meet; one `drawCircle` cannot.
class _RingPainter extends CustomPainter {
  const _RingPainter({required this.colour, required this.strokeWidth});

  final Color colour;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    canvas.drawCircle(
      size.center(Offset.zero),
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..color = colour,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.colour != colour || old.strokeWidth != strokeWidth;
}
