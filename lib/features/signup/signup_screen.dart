import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/components/app_text_field.dart';
import 'package:fluxa/components/auth_card.dart';
import 'package:fluxa/components/brand_blob.dart';
import 'package:fluxa/components/fluxa_backdrop.dart';
import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/components/inline_link.dart';
import 'package:fluxa/components/primary_button.dart';
import 'package:fluxa/components/soft_shadow.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/signup/cubit/signup_cubit.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Intrinsic aspect ratio of [AppAssets.splashArt] (313 × 372).
const double _mascotAspect = 313 / 372;

/// The mascot sits on the blob, overlapping the card's top-right corner.
const double _mascotWidthFactor = 0.26;

/// The blob sits mostly off the right edge, showing as a half-circle from the right.
const double _blobDiameterFactor = 1.70;
const double _blobRightFactor = -0.95;
const double _blobTopFactor = 0.22;

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupCubit>(
      create: (_) => SignupCubit(),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatefulWidget {
  const _SignupView();

  @override
  State<_SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<_SignupView> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = context.screenWidth;
    final double height = context.screenHeight;
    final double mascotWidth = width * _mascotWidthFactor;
    final double blob = 580;

    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: <Widget>[
            const FluxaBackdrop(),

            // Colours the top-right corner; the card is translucent, so it
            // tints the card's right edge too.
            Positioned(
              right: width * _blobRightFactor,
              top: 8,
              child: BrandBlob(diameter: blob),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.wp(0.035)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: context.hp(0.025)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.wp(0.035),
                      ),
                      child: Text(
                        AppStrings.signUpTitle,
                        style: AppTextStyles.wordmark.copyWith(
                          fontSize: context.sp(60),
                        ),
                      ),
                    ),
                    SizedBox(height: context.hp(0.012)),

                    // Mascot overlaps the card's top-right corner.
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: mascotWidth / _mascotAspect * 0.90,
                          ),
                          child: _form(context),
                        ),
                        Positioned(
                          top: -mascotWidth / _mascotAspect * 0.0001,
                          right: context.wp(0.02),
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
    );
  }

  Widget _form(BuildContext context) {
    final double gap = context.r(24);

    return AuthCard(
      child: BlocBuilder<SignupCubit, SignupState>(
        builder: (BuildContext context, SignupState state) {
          final SignupCubit cubit = context.read<SignupCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppTextField(
                label: AppStrings.fullName,
                controller: _fullName,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: gap),
              AppTextField(
                label: AppStrings.email,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: gap),
              AppTextField(
                label: AppStrings.password,
                controller: _password,
                obscure: state.obscurePassword,
                textInputAction: TextInputAction.next,
                onToggleObscure: cubit.togglePasswordVisibility,
              ),
              SizedBox(height: gap),
              AppTextField(
                label: AppStrings.confirmPassword,
                controller: _confirm,
                obscure: state.obscureConfirm,
                textInputAction: TextInputAction.done,
                onToggleObscure: cubit.toggleConfirmVisibility,
              ),
              SizedBox(height: context.r(34)),
              Center(
                child: PrimaryButton(
                  label: AppStrings.signUpAction,
                  // No flow parameter: the signup path through verification
                  // ends at login, which is the router's default.
                  onPressed: () => context.goNamed(
                    AppRoutes.verification,
                    queryParameters: <String, String>{
                      if (_email.text.isNotEmpty)
                        AppRoutes.emailParam: _email.text,
                    },
                  ),
                ),
              ),
              SizedBox(height: context.r(14)),
              InlineLink(
                prompt: AppStrings.haveAccountPrompt,
                action: AppStrings.login,
                onTap: () => context.goNamed(AppRoutes.login),
              ),
            ],
          );
        },
      ),
    );
  }
}
