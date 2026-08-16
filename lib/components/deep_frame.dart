import 'package:flutter/material.dart';

import 'package:fluxa/components/back_scope.dart';
import 'package:fluxa/components/circle_chevron_button.dart';
import 'package:fluxa/components/fluxa_backdrop.dart';
import 'package:fluxa/components/gradient_background.dart';
import 'package:fluxa/routes/app_nav.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// The shared shell for the teal frames: verification and the three steps of
/// password recovery.
///
/// Each of those screens is the same surface with a different centred column,
/// so the wash, the watermark and the corner chevron live here rather than
/// being repeated four times.
class DeepFrame extends StatelessWidget {
  const DeepFrame({super.key, required this.child, this.upRoute});

  /// The centred content column.
  final Widget child;

  /// The route one level up. It wires the top-right chevron *and* the system
  /// back, so the two cannot disagree. Omitted, the frame has neither.
  final String? upRoute;

  @override
  Widget build(BuildContext context) {
    final String? up = upRoute;
    if (up == null) return _frame(context);

    return BackScope(upRoute: up, child: _frame(context));
  }

  Widget _frame(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        gradient: AppColors.deepGradient,
        child: Stack(
          children: <Widget>[
            // Sits low in the frame, and dialled back because the export is
            // tuned for the pale wash.
            const FluxaBackdrop(
              alignment: Alignment.bottomCenter,
              opacity: 0.5,
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: context.wp(0.06)),
                  child: child,
                ),
              ),
            ),

            if (upRoute != null)
              Positioned(
                top: MediaQuery.paddingOf(context).top + context.r(8),
                right: context.wp(0.05),
                child: CircleChevronButton(
                  onPressed: () => context.backOr(upRoute!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
