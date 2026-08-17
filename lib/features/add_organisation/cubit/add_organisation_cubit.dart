import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxa/api/api_client.dart';
import 'package:fluxa/api/organisations_api.dart';
import 'package:fluxa/api/request_status.dart';
import 'package:fluxa/constants/app_strings.dart';

part 'add_organisation_state.dart';

/// Files a new organisation.
class AddOrganisationCubit extends Cubit<AddOrganisationState> {
  AddOrganisationCubit(this._api) : super(const AddOrganisationState());

  final OrganisationsApi _api;

  Future<void> submit({
    required String name,
    required String phone,
    required String latitude,
    required String longitude,
  }) async {
    if (state.status.isLoading) return;

    // Caught here rather than at the server so an empty form costs no round
    // trip; anything subtler is the backend's call.
    if (name.trim().isEmpty || phone.trim().isEmpty) {
      emit(state.failed(AppStrings.organisationMissingFields));
      return;
    }

    // The map is the only way to set these, so an empty pair means no pin was
    // dropped — and that reads better than a rejection from the server.
    if (latitude.trim().isEmpty || longitude.trim().isEmpty) {
      emit(state.failed(AppStrings.organisationMissingLocation));
      return;
    }

    emit(state.copyWith(status: RequestStatus.loading, clearError: true));

    try {
      await _api.create(
        name: name.trim(),
        phone: phone.trim(),
        latitude: latitude.trim(),
        longitude: longitude.trim(),
      );
      if (isClosed) return;
      emit(state.copyWith(status: RequestStatus.success));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.failed(e.message));
    }
  }
}
