import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxa/components/fluxa_backdrop.dart';
import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/components/inline_link.dart';
import 'package:fluxa/components/otp_input.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/verification/cubit/verification_cubit.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Code entry, on the deep teal surface.
///
/// Reached from signup and from password recovery; [email] is the address the
/// code went to. Until an auth backend routes a real one through, the frame
/// falls back to the placeholder the design is mocked up with.
class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key, this.email, this.onConfirm});

  final String? email;

  /// Left null until there is a backend to check the code against.
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
    return Scaffold(
      body: GradientBackground(
        gradient: AppColors.deepGradient,
        child: Stack(
          children: <Widget>[
            // Sits low in the frame, as in the design.
            const FluxaBackdrop(
              alignment: Alignment.bottomCenter,
              opacity: 0.5,
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: context.wp(0.06)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Held narrower than the code row so the prompt breaks
                      // over two lines, as the design sets it.
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
                      BlocBuilder<VerificationCubit, VerificationState>(
                        buildWhen: (VerificationState a, VerificationState b) =>
                            a.length != b.length,
                        builder:
                            (BuildContext context, VerificationState state) =>
                                OtpInput(
                                  length: state.length,
                                  onChanged: context
                                      .read<VerificationCubit>()
                                      .codeChanged,
                                ),
                      ),
                      SizedBox(height: context.r(14)),
                      BlocBuilder<VerificationCubit, VerificationState>(
                        builder:
                            (BuildContext context, VerificationState state) =>
                                _ConfirmButton(
                                  onPressed: state.isComplete
                                      ? () => onConfirm?.call(state.code)
                                      : null,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The pill on the deep surface: a tint of the ground rather than a fill, with
/// a light hairline — the design's button reads as recessed, not raised.
class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final BorderRadius radius = BorderRadius.circular(context.r(20));

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Material(
        color: AppColors.tealDark.withValues(alpha: 0.55),
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: AppColors.onDeepMuted, width: 1.2),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: context.r(34),
              vertical: context.r(9),
            ),
            child: Text(
              AppStrings.confirm,
              style: AppTextStyles.deepButton.copyWith(
                fontSize: context.sp(17),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
