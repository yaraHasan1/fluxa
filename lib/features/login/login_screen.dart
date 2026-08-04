import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/components/app_text_field.dart';
import 'package:fluxa/components/auth_card.dart';
import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/components/soft_shadow.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/login/cubit/login_cubit.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Intrinsic aspect ratio of [AppAssets.splashArt] (313 × 372).
const double _mascotAspect = 313 / 372;

/// The mascot perches on the card's top edge, overlapping it.
const double _mascotWidthFactor = 0.26;

/// The ribbon sweeps across under the title, mirrored from the splash export.
const double _ribbonWidthFactor = 1.05;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = context.screenWidth;
    final double mascotWidth = width * _mascotWidthFactor;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.wp(0.035)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: context.hp(0.03)),

                // Title and ribbon share a stack so the ribbon can run behind
                // the wordmark and off the right edge.
                SizedBox(
                  height: context.hp(0.26),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Positioned(
                        left: -width * 0.02,
                        top: context.hp(0.05),
                        width: width * _ribbonWidthFactor,
                        child: IgnorePointer(
                          // The splash export runs the other way; mirroring it
                          // gives the sweep the design shows here.
                          child: Transform.flip(
                            flipX: true,
                            child: SvgPicture.asset(
                              AppAssets.splashSwoosh,
                              width: width * _ribbonWidthFactor,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: context.wp(0.06)),
                        child: Text(
                          AppStrings.loginTitle,
                          style: AppTextStyles.wordmark.copyWith(
                            fontSize: context.sp(52),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Mascot overlaps the card's top-right corner.
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: mascotWidth / _mascotAspect * 0.42,
                      ),
                      child: _form(context),
                    ),
                    Positioned(
                      right: context.wp(0.04),
                      child: IgnorePointer(
                        child: SoftShadow(
                          blur: mascotWidth * 0.05,
                          offset: Offset(0, mascotWidth * 0.02),
                          child: SvgPicture.asset(
                            AppAssets.splashArt,
                            width: mascotWidth,
                            fit: BoxFit.contain,
                            semanticsLabel: AppStrings.semanticsLogo,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: context.hp(0.04)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return AuthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppTextField(
            label: AppStrings.email,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: context.r(18)),
          BlocBuilder<LoginCubit, LoginState>(
            builder: (BuildContext context, LoginState state) => AppTextField(
              label: AppStrings.password,
              controller: _password,
              obscure: state.obscurePassword,
              textInputAction: TextInputAction.done,
              onToggleObscure: () =>
                  context.read<LoginCubit>().togglePasswordVisibility(),
            ),
          ),
          SizedBox(height: context.r(12)),
          _InlineLink(
            prompt: AppStrings.forgotPasswordPrompt,
            action: AppStrings.resetPassword,
            align: TextAlign.end,
            onTap: () => context.goNamed(AppRoutes.forgetPassword),
          ),
          SizedBox(height: context.r(18)),
          Center(child: _LoginButton(onPressed: () {})),
          SizedBox(height: context.r(14)),
          _InlineLink(
            prompt: AppStrings.noAccountPrompt,
            action: AppStrings.signUp,
            align: TextAlign.center,
            onTap: () => context.goNamed(AppRoutes.signup),
          ),
        ],
      ),
    );
  }
}

/// The filled action. Unlike [PrimaryButton] it carries a trailing glyph.
class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.teal,
      borderRadius: BorderRadius.circular(context.r(22)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.r(52),
            vertical: context.r(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppStrings.login,
                style: AppTextStyles.button.copyWith(fontSize: context.sp(19)),
              ),
              SizedBox(width: context.r(8)),
              Icon(Icons.login, size: context.r(19), color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small print with one tappable run at the end.
class _InlineLink extends StatelessWidget {
  const _InlineLink({
    required this.prompt,
    required this.action,
    required this.align,
    required this.onTap,
  });

  final String prompt;
  final String action;
  final TextAlign align;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double size = context.sp(11.5);

    return GestureDetector(
      onTap: onTap,
      child: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: prompt,
              style: AppTextStyles.helper.copyWith(fontSize: size),
            ),
            TextSpan(
              text: action,
              style: AppTextStyles.helperAction.copyWith(fontSize: size),
            ),
          ],
        ),
        textAlign: align,
      ),
    );
  }
}
