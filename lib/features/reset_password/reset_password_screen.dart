import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxa/components/app_text_field.dart';
import 'package:fluxa/components/deep_button.dart';
import 'package:fluxa/components/deep_frame.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/reset_password/cubit/reset_password_cubit.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Final step of password recovery: choose the new password.
///
/// Also the shape the settings "change password" frame uses.
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, this.onConfirm});

  /// Given the chosen password. Storing it needs the auth backend.
  final ValueChanged<String>? onConfirm;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResetPasswordCubit>(
      create: (_) => ResetPasswordCubit(),
      child: _ResetPasswordView(onConfirm: onConfirm),
    );
  }
}

class _ResetPasswordView extends StatefulWidget {
  const _ResetPasswordView({this.onConfirm});

  final ValueChanged<String>? onConfirm;

  @override
  State<_ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<_ResetPasswordView> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _confirm() => widget.onConfirm?.call(_password.text);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      builder: (BuildContext context, ResetPasswordState state) {
        final ResetPasswordCubit cubit = context.read<ResetPasswordCubit>();

        return DeepFrame(
          onNext: _confirm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppStrings.newPasswordTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.deepBody.copyWith(
                  fontSize: context.sp(16),
                ),
              ),
              SizedBox(height: context.r(22)),
              AppTextField(
                label: AppStrings.password,
                labelStyle: AppTextStyles.deepHelper,
                controller: _password,
                obscure: state.obscurePassword,
                textInputAction: TextInputAction.next,
                onToggleObscure: cubit.togglePasswordVisibility,
              ),
              SizedBox(height: context.r(18)),
              AppTextField(
                label: AppStrings.confirmPassword,
                labelStyle: AppTextStyles.deepHelper,
                controller: _confirmPassword,
                obscure: state.obscureConfirm,
                textInputAction: TextInputAction.done,
                onToggleObscure: cubit.toggleConfirmVisibility,
              ),
              SizedBox(height: context.r(22)),
              Center(
                child: DeepButton(
                  label: AppStrings.confirm,
                  onPressed: _confirm,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
