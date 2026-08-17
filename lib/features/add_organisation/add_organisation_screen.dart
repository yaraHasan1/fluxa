import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:fluxa/api/organisations_api.dart';
import 'package:fluxa/components/app_text_field.dart';
import 'package:fluxa/components/location_picker.dart';
import 'package:fluxa/components/panel_dialog.dart';
import 'package:fluxa/constants/app_strings.dart';
import 'package:fluxa/features/add_organisation/cubit/add_organisation_cubit.dart';
import 'package:fluxa/routes/app_routes.dart';
import 'package:fluxa/theme/app_colors.dart';
import 'package:fluxa/theme/app_text_styles.dart';
import 'package:fluxa/utils/injector.dart';
import 'package:fluxa/utils/responsive_extension.dart';

/// Files a new organisation: the four fields the endpoint takes.
class AddOrganisationScreen extends StatelessWidget {
  const AddOrganisationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddOrganisationCubit>(
      create: (_) => AddOrganisationCubit(sl<OrganisationsApi>()),
      child: const _AddOrganisationView(),
    );
  }
}

class _AddOrganisationView extends StatefulWidget {
  const _AddOrganisationView();

  @override
  State<_AddOrganisationView> createState() => _AddOrganisationViewState();
}

class _AddOrganisationViewState extends State<_AddOrganisationView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  /// Null until the map is tapped.
  LatLng? _point;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  /// Six decimals is roughly a tenth of a metre — past anything a tap on a
  /// map can mean.
  static String _coordinate(double value) => value.toStringAsFixed(6);

  void _submit() {
    final LatLng? point = _point;

    context.read<AddOrganisationCubit>().submit(
      name: _name.text,
      phone: _phone.text,
      latitude: point == null ? '' : _coordinate(point.latitude),
      longitude: point == null ? '' : _coordinate(point.longitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddOrganisationCubit, AddOrganisationState>(
      // The organisation comes back pending review, which is exactly what the
      // request-sent panel says — so that is where a filed one lands.
      listenWhen: (AddOrganisationState was, AddOrganisationState now) =>
          !was.status.isSuccess && now.status.isSuccess,
      listener: (BuildContext context, _) =>
          context.goNamed(AppRoutes.requestSent),
      builder: (BuildContext context, AddOrganisationState state) {
        final bool busy = state.status.isLoading;

        return PanelDialog(
          title: AppStrings.addOrganisationTitle,
          submitLabel: busy ? AppStrings.sending : AppStrings.submit,
          // Still wired while busy — the panel drops the whole action row for
          // a null, and the cubit already refuses a second send.
          onSubmit: _submit,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppTextField(
                label: AppStrings.organisationNameLabel,
                controller: _name,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: context.r(14)),
              AppTextField(
                label: AppStrings.organisationPhoneLabel,
                controller: _phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: context.r(14)),

              // One coordinate, picked rather than typed: the endpoint wants
              // latitude and longitude, and nobody knows their own to six
              // decimal places.
              Text(
                AppStrings.organisationLocationLabel,
                style: AppTextStyles.fieldLabel.copyWith(
                  fontSize: context.sp(15),
                ),
              ),
              SizedBox(height: context.r(7)),
              LocationPicker(
                point: _point,
                onPicked: (LatLng picked) => setState(() => _point = picked),
              ),

              if (state.error != null) ...<Widget>[
                SizedBox(height: context.r(12)),
                Text(
                  state.error!,
                  style: AppTextStyles.helper.copyWith(
                    fontSize: context.sp(12),
                    color: AppColors.statusBadDeep,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
