import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/components/primary_button.dart';
import 'package:fluxa/components/soft_shadow.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Intrinsic aspect ratio of [AppAssets.splashArt] (313 × 372).
const double _artAspect = 313 / 372;

/// The mascot is the same export as the splash, laid out far wider than the
/// screen and pushed off the left and bottom edges so only the head, one arm
/// and the chest bolt stay in frame — the crop the design calls for.
const double _artWidthFactor = 1.59;
const double _artLeftFactor = -0.272;
const double _artTopFactor = 0.19;

/// The welcome frame: title, supporting copy, a cropped mascot and the
/// forward action.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SizedBox.expand(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double width = constraints.maxWidth;
              final double height = constraints.maxHeight;
              final double artWidth = width * _artWidthFactor;

              return Stack(
                children: <Widget>[
                  // Mascot first: the copy sits over it, as in the design.
                  Positioned(
                    left: width * _artLeftFactor,
                    top: height * _artTopFactor,
                    width: artWidth,
                    height: artWidth / _artAspect,
                    child: IgnorePointer(
                      // Without this the near-white chassis has no edge
                      // against the pale background and the mascot reads as a
                      // floating dark face.
                      child: SoftShadow(
                        blur: artWidth * 0.022,
                        offset: Offset(0, artWidth * 0.006),
                        child: SvgPicture.asset(
                          AppAssets.FluxabIG,
                          width: artWidth,
                          fit: BoxFit.contain,
                          semanticsLabel: AppStrings.semanticsLogo,
                        ),
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.wp(0.07),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: height * 0.075),
                          Center(
                            child: Text(
                              AppStrings.welcomeTitle,
                              style: AppTextStyles.heading.copyWith(
                                fontSize: context.sp(30),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.028),
                          Padding(
                            // The copy is inset a little further than the
                            // button below it.
                            padding: EdgeInsets.symmetric(
                              horizontal: context.wp(0.026),
                            ),
                            child: Text(
                              AppStrings.welcomeBody,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.subtitle.copyWith(
                                fontSize: context.sp(19),
                              ),
                            ),
                          ),
                          const Spacer(),
                          PrimaryButton(
                            label: AppStrings.next,
                            onPressed: () => context.goNamed(AppRoutes.login),
                          ),
                          SizedBox(height: height * 0.035),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
