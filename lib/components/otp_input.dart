import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// A row of single-character boxes for entering a one-time code.
///
/// Shared by the signup verification frame and the password-recovery flow,
/// which are the same design with different copy above them.
///
/// Typing advances to the next box and backspace on an empty box steps back,
/// so the row behaves like one field rather than [length] separate ones.
class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    this.length = 5,
    this.onChanged,
    this.onCompleted,
  });

  final int length;

  /// Fires on every edit with the code so far, which may be incomplete.
  final ValueChanged<String>? onChanged;

  /// Fires once every box holds a character.
  final ValueChanged<String>? onCompleted;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _nodes = List<FocusNode>.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final TextEditingController c in _controllers) {
      c.dispose();
    }
    for (final FocusNode n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _code =>
      _controllers.map((TextEditingController c) => c.text).join();

  void _onChanged(int index, String value) {
    // A paste or a fast keystroke can deliver more than one character; keep
    // the first and let the rest fall through to the boxes that follow.
    if (value.length > 1) {
      _distribute(index, value);
    } else if (value.isNotEmpty && index < widget.length - 1) {
      _nodes[index + 1].requestFocus();
    }

    final String code = _code;
    widget.onChanged?.call(code);
    if (code.length == widget.length) {
      _nodes[index].unfocus();
      widget.onCompleted?.call(code);
    }
  }

  void _distribute(int start, String value) {
    for (int i = 0; i < value.length && start + i < widget.length; i++) {
      _controllers[start + i].text = value[i];
    }
    final int last = (start + value.length).clamp(0, widget.length - 1);
    _nodes[last].requestFocus();
  }

  /// Backspace on an already-empty box moves focus back and clears that one,
  /// which is what users expect from a segmented code field.
  KeyEventResult _onKey(int index, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.backspace) {
      return KeyEventResult.ignored;
    }
    if (_controllers[index].text.isNotEmpty || index == 0) {
      return KeyEventResult.ignored;
    }

    _controllers[index - 1].clear();
    _nodes[index - 1].requestFocus();
    widget.onChanged?.call(_code);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        for (int i = 0; i < widget.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.r(4)),
              // The box is sized by the field's own padding rather than an
              // AspectRatio: a TextField will not stretch to fill a parent, so
              // wrapping it in one leaves a short field centred in a tall box.
              child: Builder(
                builder: (BuildContext context) => Focus(
                  onKeyEvent: (_, KeyEvent e) => _onKey(i, e),
                  child: TextField(
                    controller: _controllers[i],
                    focusNode: _nodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    // Not maxLength: that would render a counter under the row.
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: AppTextStyles.fieldInput.copyWith(
                      fontSize: context.sp(20),
                    ),
                    cursorColor: AppColors.teal,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: context.r(13),
                      ),
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.r(10)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.r(10)),
                        borderSide: const BorderSide(
                          color: AppColors.tealDark,
                          width: 1.6,
                        ),
                      ),
                    ),
                    onChanged: (String v) => _onChanged(i, v),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
