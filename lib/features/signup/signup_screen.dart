import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluxa/components/app_text_field.dart';
import 'package:fluxa/components/auth_card.dart';
import 'package:fluxa/components/brand_blob.dart';
import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/components/primary_button.dart';
import 'package:fluxa/components/soft_shadow.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/signup/cubit/signup_cubit.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Intrinsic aspect ratio of [AppAssets.splashArt] (313 × 372).
const double _mascotAspect = 313 / 372;

/// The mascot sits on the blob, overlapping the card's top-right corner.
const double _mascotWidthFactor = 0.26;

/// The blob is mostly off the top-right corner; only its lower-left arc shows.
const double _blobDiameterFactor = 1.70;
const double _blobRightFactor = -1.15;
const double _blobTopFactor = -0.356;

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
    final double blob = width * _blobDiameterFactor;

    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: <Widget>[
            // Colours the top-right corner; the card is translucent, so it
            // tints the card's right edge too.
            Positioned(
              right: width * _blobRightFactor,
              top: height * _blobTopFactor,
              child: BrandBlob(diameter: blob),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.wp(0.035)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: context.hp(0.035)),
                    Padding(
                      padding: EdgeInsets.only(left: context.wp(0.035)),
                      child: Text(
                        AppStrings.signUpTitle,
                        style: AppTextStyles.wordmark.copyWith(
                          fontSize: context.sp(40),
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
                            top: mascotWidth / _mascotAspect * 0.40,
                          ),
                          child: _form(context),
                        ),
                        Positioned(
                          right: context.wp(0.02),
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
                  onPressed: () {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
