import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Registers the bundled display face with the test binding.
///
/// Widget tests ship a stand-in font that paints every glyph as a filled box,
/// so without this a golden cannot show whether the wordmark is right — only
/// where it sits. The UI face is still the platform default and has no bundled
/// file, so body copy stays boxed.
Future<void> loadDisplayFont() async {
  final ByteData data = ByteData.sublistView(
    await File('assets/font/SirinStencil-Regular.ttf').readAsBytes(),
  );
  final FontLoader loader = FontLoader('Sirin Stencil')
    ..addFont(Future<ByteData>.value(data));
  await loader.load();
}
