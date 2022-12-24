import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:service365_admin_panel/landing_screen/banner/model/advertisement_model.dart';
import 'package:service365_admin_panel/landing_screen/section/repository/section_repository.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';
part 'section_management_state.dart';

class SectionManagementCubit extends Cubit<SectionmanagementState> {
  SectionManagementCubit() : super(SectionmanagementInitial());
  final _sectionRepository = SectionRepository();

  Future<void> addSection({
    required BuildContext context,
    required AdvertisementModel advertisementModel,
  }) async {
    emit(ShowSectionLoadingSpinner());
    try {
      await _sectionRepository.addSectionToFirebase(
        advertisementModel: advertisementModel,
      );
      emit(SectionmanagementInitial());
      ShowSnackBar.showSnackBar(
        context,
        "'${advertisementModel.name}' successfully added",
        textAlign: TextAlign.center,
      );
      return;
    } catch (e) {
      emit(SectionmanagementInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Unable to add '${advertisementModel.name}'",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Stream<List<AdvertisementModel?>> fetchSections() {
    return _sectionRepository.streamSectionsLog();
  }

  Future<void> deleteSection({
    required BuildContext context,
    required AdvertisementModel advertisementModel,
  }) async {
    emit(ShowSectionLoadingSpinner());
    try {
      await _sectionRepository.deleteSectionFromFirebase(
        advertisementModel: advertisementModel,
      );
      emit(SectionmanagementInitial());
      ShowSnackBar.showSnackBar(
        context,
        "'${advertisementModel.name}' successfully deleted",
        textAlign: TextAlign.center,
      );
      return;
    } catch (e) {
      emit(SectionmanagementInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Unable to delete '${advertisementModel.name}'",
        textAlign: TextAlign.center,
      );
      return;
    }
  }
}
