import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/components/corner_arcs.dart';
import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/components/soft_shadow.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/splash/cubit/splash_cubit.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Intrinsic aspect ratio of [AppAssets.splashArt] (313 × 372).
const double _artAspect = 313 / 372;

/// The brand frame: corner arcs, the mascot group, and the wordmark lockup.
///
/// Every position is a fraction of the viewport, matched to the design frame,
/// so the composition holds from small phones through tablets.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (_) => SplashCubit()..start(),
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (SplashState prev, SplashState next) =>
            next is SplashComplete,
        listener: (BuildContext context, _) =>
            context.goNamed(AppRoutes.onboarding),
        child: const _SplashView(),
      ),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    // The arcs bleed off two corners of the physical screen, so they sit
    // outside the content column that constrains the lockup on tablets. The
    // 170×167 viewBox carries generous padding around the three arcs, so the
    // box is laid out wider than the artwork that shows.
    final double arcSize = context.wp(0.46);

    return Scaffold(
      body: GradientBackground(
        child: SizedBox.expand(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: CornerArcs(corner: ArcCorner.topLeft, size: arcSize),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CornerArcs(corner: ArcCorner.bottomRight, size: arcSize),
              ),
              Center(
                child: SizedBox(
                  width: context.contentMaxWidth,
                  child: const _SplashContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        // Fractions read off the design frame: the mascot group spans ~60% of
        // the frame width, and the 313×372 viewBox carries margin around it.
        final double artWidth = width * 0.72;
        final double artHeight = artWidth / _artAspect;
        final double artTop = height * 0.50 - artHeight / 2;

        final double swooshWidth = width * 0.68;

        return Stack(
          children: <Widget>[
            // Cable tail, behind the mascot and reaching wider than it.
            Positioned(
              left: (width - swooshWidth) / 2,
              top: artTop + artHeight * 0.60,
              width: swooshWidth,
              child: SvgPicture.asset(
                AppAssets.splashSwoosh,
                width: swooshWidth,
                fit: BoxFit.contain,
              ),
            ),

            // Mascot group, centred just above the vertical midpoint.
            Positioned(
              left: (width - artWidth) / 2,
              top: artTop,
              width: artWidth,
              child: SoftShadow(
                blur: artWidth * 0.05,
                offset: Offset(0, artWidth * 0.012),
                child: SvgPicture.asset(
                  AppAssets.splashArt,
                  width: artWidth,
                  fit: BoxFit.contain,
                  semanticsLabel: AppStrings.semanticsLogo,
                ),
              ),
            ),

            // Wordmark lockup, anchored to the lower left.
            Positioned(
              left: width * 0.077,
              top: height * 0.678,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.wordmark.copyWith(
                      fontSize: context.sp(26),
                    ),
                  ),
                  SizedBox(height: height * 0.012),
                  Padding(
                    // The tagline is indented under the wordmark in the design.
                    padding: EdgeInsets.only(left: width * 0.065),
                    child: Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: AppStrings.taglineLead,
                            style: AppTextStyles.tagline.copyWith(
                              fontSize: context.sp(16),
                            ),
                          ),
                          TextSpan(
                            text: AppStrings.taglineAccent,
                            style: AppTextStyles.taglineAccent.copyWith(
                              fontSize: context.sp(16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
