import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:service365_admin_panel/landing_screen/banner/model/advertisement_model.dart';
import 'package:service365_admin_panel/landing_screen/banner/repository/discount_repository.dart';
import 'package:service365_admin_panel/utility/image_picker.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';
part 'bannermanagement_state.dart';

class BannerManagementCubit extends Cubit<BannerManagementState> {
  BannerManagementCubit() : super(BannerManagementInitial());
  final discountRepository = DiscountRepository();

  Future<void> addDiscount({
    required BuildContext context,
    required AdvertisementModel advertisementModel,
    required PickedImageModel pickedImage,
  }) async {
    emit(ShowBannerLoadingSpinner());
    try {
      await discountRepository.adddiscountToFirebase(
        advertisementModel: advertisementModel,
        pickedImage: pickedImage,
      );
      emit(BannerManagementInitial());

      ShowSnackBar.showSnackBar(
        context,
        "'${advertisementModel.name}' successfully added",
        textAlign: TextAlign.center,
      );
      return;
    } catch (e) {
      emit(BannerManagementInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Unable to add '${advertisementModel.name}'",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Future<void> deleteDiscount({
    required BuildContext context,
    required AdvertisementModel advertisementModel,
  }) async {
    emit(ShowBannerLoadingSpinner());
    try {
      await discountRepository.deletediscountFromFirebase(
        advertisementModel: advertisementModel,
      );
      emit(BannerManagementInitial());
      ShowSnackBar.showSnackBar(
        context,
        "'${advertisementModel.name}' successfully deleted",
        textAlign: TextAlign.center,
      );
      return;
    } catch (e) {
      emit(BannerManagementInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Unable to delete '${advertisementModel.name}'",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Future<void> addAdv({
    required BuildContext context,
    required AdvertisementModel advertisementModel,
    required PickedImageModel pickedImage,
  }) async {
    emit(ShowBannerLoadingSpinner());
    try {
      await discountRepository.addAdvToFirebase(
        advModel: advertisementModel,
        pickedImage: pickedImage,
      );
      emit(BannerManagementInitial());

      ShowSnackBar.showSnackBar(
        context,
        "'${advertisementModel.name}' successfully added",
        textAlign: TextAlign.center,
      );
      return;
    } catch (e) {
      emit(BannerManagementInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Unable to add '${advertisementModel.name}'",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Future<void> deleteAdv({
    required BuildContext context,
    required AdvertisementModel advertisementModel,
  }) async {
    emit(ShowBannerLoadingSpinner());
    try {
      await discountRepository.deleteAdvFromFirebase(
        advertisementModel: advertisementModel,
      );
      emit(BannerManagementInitial());
      ShowSnackBar.showSnackBar(
        context,
        "'${advertisementModel.name}' successfully deleted",
        textAlign: TextAlign.center,
      );
      return;
    } catch (e) {
      emit(BannerManagementInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Unable to delete '${advertisementModel.name}'",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Stream<List<AdvertisementModel?>> fetchDiscount() {
    return discountRepository.streamdiscountLog();
  }

  Stream<List<AdvertisementModel?>> fetchAdv() {
    return discountRepository.streamAdvLog();
  }
}
