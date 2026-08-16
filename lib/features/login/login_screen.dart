import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/api/auth_api.dart';
import 'package:fluxa/api/token_store.dart';
import 'package:fluxa/components/app_text_field.dart';
import 'package:fluxa/components/auth_card.dart';
import 'package:fluxa/components/back_scope.dart';
import 'package:fluxa/components/fluxa_backdrop.dart';
import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/components/inline_link.dart';
import 'package:fluxa/components/soft_shadow.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/components/app_message.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/login/cubit/login_cubit.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/injector.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Intrinsic aspect ratio of [AppAssets.fluxaSide] (159 × 251).
const double _mascotAspect = 159 / 251;

/// The mascot perches on the card's top edge, overlapping it.
const double _mascotWidthFactor = 0.26;

/// The ribbon sweeps across under the title.
const double _ribbonWidthFactor = 1.05;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(sl<AuthApi>(), sl<TokenStore>()),
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (LoginState a, LoginState b) => a.status != b.status,
        listener: (BuildContext context, LoginState state) {
          if (state.status.isSuccess) {
            showAppMessage(context, AppStrings.signedIn);
            context.goNamed(AppRoutes.dashboard);
          } else if (state.status.isFailure && state.error != null) {
            // The server's own wording, not a generic line — a wrong password
            // and an unapproved account are different problems.
            showAppMessage(context, state.error!, isError: true);
          }
        },
        child: const _LoginView(),
      ),
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

    // Back from the sign-in form returns to the welcome frame rather than
    // closing the app, which is what an empty stack would otherwise do.
    return BackScope(
      upRoute: AppRoutes.onboarding,
      child: Scaffold(
      body: GradientBackground(
        child: Stack(
          children: <Widget>[
            const FluxaBackdrop(),
            SafeArea(
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
                            top: context.hp(0.02),
                            child: IgnorePointer(
                              child: SvgPicture.asset(
                                AppAssets.loginRibbon,
                                width: width * _ribbonWidthFactor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: context.wp(0.12),
                              top: context.hp(0.07),
                            ),
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) =>
                                  const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                      AppColors.navy,
                                      AppColors.teal,
                                    ],
                                  ).createShader(bounds),
                              blendMode: BlendMode.srcIn,
                              child: Text(
                                AppStrings.loginTitle,
                                style: AppTextStyles.wordmark.copyWith(
                                  fontSize: context.sp(90),
                                  color: Colors.white,
                                ),
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
                          right: context.wp(0.03),
                          top: -mascotWidth / _mascotAspect * 0.12,
                          child: IgnorePointer(
                            child: SoftShadow(
                              blur: mascotWidth * 0.05,
                              offset: Offset(0, mascotWidth * 0.02),
                              child: SvgPicture.asset(
                                AppAssets.fluxaSide,
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
          ],
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: InlineLink(
              prompt: AppStrings.forgotPasswordPrompt,
              action: AppStrings.resetPassword,
              align: TextAlign.end,
              onTap: () => context.goNamed(AppRoutes.forgetPassword),
            ),
          ),
          SizedBox(height: context.r(18)),
          Center(
            child: BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (LoginState a, LoginState b) => a.status != b.status,
              builder: (BuildContext context, LoginState state) => _LoginButton(
                busy: state.status.isLoading,
                // Null while in flight, so the button cannot be pressed twice.
                onPressed: state.status.isLoading
                    ? null
                    : () => context.read<LoginCubit>().signIn(
                        email: _email.text,
                        password: _password.text,
                      ),
              ),
            ),
          ),
          SizedBox(height: context.r(14)),
          InlineLink(
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
  const _LoginButton({required this.onPressed, this.busy = false});

  final VoidCallback? onPressed;

  /// Swaps the glyph for a spinner while the request is in flight. The label
  /// stays put so the pill does not change width mid-press.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.teal,
      borderRadius: BorderRadius.circular(context.r(16)),
      // clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.r(52),
            vertical: context.r(2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppStrings.login,
                style: AppTextStyles.button.copyWith(
                  fontSize: context.sp(24),
                  color: AppColors.mintLight,
                ),
              ),
              SizedBox(width: context.r(8)),
              // The export carries its own pale mint fill, which is what the
              // design shows against the teal pill — so it is not re-tinted.
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: context.r(30),
                  width: context.r(30),
                  child: busy
                      ? Padding(
                          padding: EdgeInsets.all(context.r(5)),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: AppColors.mintLight,
                          ),
                        )
                      : SvgPicture.asset(AppAssets.loginIcon),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
