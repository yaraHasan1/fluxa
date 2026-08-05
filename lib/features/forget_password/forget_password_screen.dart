import 'package:flutter/material.dart';

import 'package:fluxa/components/app_text_field.dart';
import 'package:fluxa/components/deep_button.dart';
import 'package:fluxa/components/deep_frame.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Step one of password recovery: ask where to send the code.
///
/// The field carries no caption in this frame — the prompt above it does that
/// job — so [AppTextField] is used without a label.
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key, this.onConfirm});

  /// Given the address entered. Sending the code needs the auth backend.
  final ValueChanged<String>? onConfirm;

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _confirm() => widget.onConfirm?.call(_email.text);

  @override
  Widget build(BuildContext context) {
    return DeepFrame(
      onNext: _confirm,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            AppStrings.resetPrompt,
            textAlign: TextAlign.center,
            style: AppTextStyles.deepBody.copyWith(fontSize: context.sp(16)),
          ),
          SizedBox(height: context.r(20)),
          AppTextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: context.r(18)),
          DeepButton(label: AppStrings.confirm, onPressed: _confirm),
        ],
      ),
    );
  }
}
