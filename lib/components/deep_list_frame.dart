import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/components/circle_chevron_button.dart';
import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/constants/app_assets.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The shell the history and notifications frames share: title, mascot, and a
/// scrolling panel of entries on the deep wash.
///
/// Both screens are the same frame with different rows, so the chrome lives
/// here and each supplies only its list.
class DeepListFrame extends StatelessWidget {
  const DeepListFrame({super.key, required this.title, required this.children});

  final String title;

  /// The rows inside the panel.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        gradient: AppColors.deepGradient,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: context.r(4),
                right: context.wp(0.05),
                child: CircleChevronButton(onPressed: () => context.pop()),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.wp(0.055)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: context.hp(0.055)),
                    _Header(title: title),
                    SizedBox(height: context.r(10)),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(context.r(10)),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.42),
                          borderRadius: BorderRadius.circular(context.r(14)),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: children.length,
                          separatorBuilder: (_, _) =>
                              SizedBox(height: context.r(10)),
                          itemBuilder: (_, int i) => children[i],
                        ),
                      ),
                    ),
                    SizedBox(height: context.hp(0.03)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Title on the left, mascot peering in from the right.
class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.wordmark.copyWith(
              fontSize: context.sp(26),
              color: AppColors.tealDark,
            ),
          ),
        ),
        SvgPicture.asset(
          AppAssets.fluxaSide,
          width: context.wp(0.17),
          fit: BoxFit.contain,
          semanticsLabel: AppStrings.semanticsLogo,
        ),
      ],
    );
  }
}
