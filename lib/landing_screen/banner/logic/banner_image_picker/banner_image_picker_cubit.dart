import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service365_admin_panel/utility/image_picker.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';

part 'banner_image_picker_state.dart';

class BannerImagePickerCubit extends Cubit<BannerImagePickerState> {
  BannerImagePickerCubit() : super(PickBannerImageInitial());
  Future<void> pickBannerImage({required BuildContext context}) async {
    // emit(ShowSpinnerDuringImagePick());
    try {
      final _image = await PickImage().pickImageFromGallery();
      if (_image.selectedImage == null) {
        emit(PickBannerImageInitial());
        ShowSnackBar.showSnackBar(context, 'No image selected');
      } else {
        emit(PickBannerImageInitial());
        emit(BannerImagepicked(pickedImageModel: _image));
      }
      return;
    } catch (error) {
      emit(PickBannerImageInitial());

      if (error is PlatformException) {
        ShowSnackBar.showSnackBar(context, error.message ?? '');
      } else {
        ShowSnackBar.showSnackBar(context, error.toString());
      }
    }
  }

  Future<void> resetImage() async {
    emit(PickBannerImageInitial());
  }
}
