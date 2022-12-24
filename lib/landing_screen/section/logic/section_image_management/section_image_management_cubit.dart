import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:service365_admin_panel/landing_screen/banner/model/advertisement_model.dart';
import 'package:service365_admin_panel/landing_screen/section/model/section_image_model.dart';
import 'package:service365_admin_panel/landing_screen/section/repository/section_repository.dart';
import 'package:service365_admin_panel/utility/image_picker.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';
part 'section_image_management_state.dart';

class SectionImageManagementCubit extends Cubit<SectionImageManagementState> {
  SectionImageManagementCubit() : super(SectionImageManagementInitial());
  final _sectionRepository = SectionRepository();

  Future<void> addSectionImageToFirebase({
    required BuildContext context,
    required PickedImageModel pickedImage,
    required AdvertisementModel advertisementModel,
    required String imageName,
  }) async {
    emit(SectionImageLoading());
    try {
      await _sectionRepository.addSectionImageToFirebase(
        advertisementModel: advertisementModel,
        pickedImage: pickedImage,
        imageName: imageName,
      );
      emit(SectionImageManagementInitial());
    } catch (e) {
      emit(SectionImageManagementInitial());
    }
  }

  Future<void> deleteSectionImage({
    required BuildContext context,
    required SectionImageModel sectionImageModel,
    required AdvertisementModel advertisementModel,
  }) async {
    try {
      await _sectionRepository.deleteSectionImageFromFirebase(
        sectionImageId: sectionImageModel.id!,
        advertisementModel: advertisementModel,
      );
      ShowSnackBar.showSnackBar(
        context,
        "'${sectionImageModel.name}' successfully deleted",
        textAlign: TextAlign.center,
      );
      return;
    } catch (e) {
      ShowSnackBar.showSnackBar(
        context,
        "Unable to delete '${sectionImageModel.name}'",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Stream<List<SectionImageModel?>> fetchSectionImages({
    required String sectionDocId,
  }) {
    return _sectionRepository.streamSectionImagesLog(
      sectionDocId: sectionDocId,
    );
  }
}
