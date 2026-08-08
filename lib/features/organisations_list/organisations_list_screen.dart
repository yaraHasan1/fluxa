import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/components/panel_dialog.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Pick which organisation to switch to.
class OrganisationsListScreen extends StatefulWidget {
  const OrganisationsListScreen({super.key, this.organisations});

  /// Supplied by the caller. Falls back to the design's stand-in names until
  /// the backend can list them.
  final List<String>? organisations;

  @override
  State<OrganisationsListScreen> createState() =>
      _OrganisationsListScreenState();
}

class _OrganisationsListScreenState extends State<OrganisationsListScreen> {
  /// TEMPORARY: the frame is mocked up with three identical rows.
  static const List<String> _placeholder = <String>[
    'company 1',
    'company 1',
    'company 1',
  ];

  int? _selected;

  @override
  Widget build(BuildContext context) {
    final List<String> items = widget.organisations ?? _placeholder;

    return PanelDialog(
      title: AppStrings.organisationsListTitle,
      onSubmit: _selected == null
          ? null
          : () => context.goNamed(AppRoutes.requestSent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < items.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: context.r(10)),
            _OrganisationPill(
              name: items[i],
              selected: _selected == i,
              onTap: () => setState(() => _selected = i),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrganisationPill extends StatelessWidget {
  const _OrganisationPill({
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.r(10)),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: context.r(8)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.r(10)),
          border: Border.all(
            color: selected ? AppColors.teal : AppColors.fieldBorder,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Text(
          name,
          style: AppTextStyles.helper.copyWith(
            fontSize: context.sp(12),
            color: AppColors.tealMid,
          ),
        ),
      ),
    );
  }
}
