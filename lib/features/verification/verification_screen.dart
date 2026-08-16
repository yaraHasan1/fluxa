import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxa/components/deep_button.dart';
import 'package:fluxa/components/deep_frame.dart';
import 'package:fluxa/components/inline_link.dart';
import 'package:fluxa/components/otp_input.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/verification/cubit/verification_cubit.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Code entry, on the deep teal surface.
///
/// Shared by signup and password recovery — the frame is identical, only the
/// destination differs, so the router supplies [onConfirm].
class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key, this.email, this.onConfirm});

  /// The address the code went to. Until an auth backend routes a real one
  /// through, the frame falls back to the placeholder it is mocked up with.
  final String? email;

  final ValueChanged<String>? onConfirm;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VerificationCubit>(
      create: (_) => VerificationCubit(),
      child: _VerificationView(email: email, onConfirm: onConfirm),
    );
  }
}

class _VerificationView extends StatelessWidget {
  const _VerificationView({this.email, this.onConfirm});

  final String? email;
  final ValueChanged<String>? onConfirm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationCubit, VerificationState>(
      builder: (BuildContext context, VerificationState state) {
        void confirm() => onConfirm?.call(state.code);

        return DeepFrame(
          // The design shows no chevron here, but a code frame with no way
          // out is a dead end, so it gets one like the frames either side.
          upRoute: AppRoutes.login,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Held narrower than the code row so the prompt breaks over two
              // lines, as the design sets it.
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: context.wp(0.72)),
                child: Text(
                  AppStrings.verificationPrompt,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.deepBody.copyWith(
                    fontSize: context.sp(15),
                  ),
                ),
              ),
              SizedBox(height: context.r(14)),
              Text(
                email ?? AppStrings.emailPlaceholder,
                textAlign: TextAlign.center,
                style: AppTextStyles.deepEmail.copyWith(
                  fontSize: context.sp(19),
                ),
              ),
              SizedBox(height: context.r(16)),
              InlineLink(
                prompt: AppStrings.noCodePrompt,
                action: AppStrings.resendCode,
                // Resending needs a backend to ask.
                onTap: () {},
                promptStyle: AppTextStyles.deepHelper,
                actionStyle: AppTextStyles.deepHelperAction,
              ),
              SizedBox(height: context.r(20)),
              OtpInput(
                length: state.length,
                onChanged: context.read<VerificationCubit>().codeChanged,
              ),
              SizedBox(height: context.r(14)),
              DeepButton(
                label: AppStrings.confirm,
                onPressed: state.isComplete ? confirm : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
