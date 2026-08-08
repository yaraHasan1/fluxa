import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fluxa/components/app_text_field.dart';
import 'package:fluxa/components/panel_dialog.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Name and size for a new organisation.
class AddOrganisationScreen extends StatefulWidget {
  const AddOrganisationScreen({super.key});

  @override
  State<AddOrganisationScreen> createState() => _AddOrganisationScreenState();
}

class _AddOrganisationScreenState extends State<AddOrganisationScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _size = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _size.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PanelDialog(
      title: AppStrings.addOrganisationTitle,
      // Creating the organisation needs a backend; for now the flow just
      // reports that the request was filed.
      onSubmit: () => context.goNamed(AppRoutes.requestSent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppTextField(
            label: AppStrings.organisationNameLabel,
            controller: _name,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: context.r(16)),
          AppTextField(
            label: AppStrings.organisationSizeLabel,
            controller: _size,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}
