import 'package:flutter/material.dart';

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
///
/// Prefer `TextStyle.shadows` for a soft halo; use this when the design calls
/// for a hard, even edge all the way round the lettering.
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
              // `color` and `foreground` are mutually exclusive; copyWith
              // drops the colour once a foreground is supplied.
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
