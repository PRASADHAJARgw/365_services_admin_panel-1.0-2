import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service365_admin_panel/utility/image_picker.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';

part 'section_imagepicker_state.dart';

class SectionImagePickerCubit extends Cubit<SectionImagePickerState> {
  SectionImagePickerCubit() : super(PickSectionImageInitial());
  Future<void> pickSectionImage({required BuildContext context}) async {
    // emit(ShowSpinnerDuringImagePick());
    try {
      final _image = await PickImage().pickImageFromGallery();
      if (_image.selectedImage == null) {
        emit(PickSectionImageInitial());
        ShowSnackBar.showSnackBar(context, 'No image selected');
      } else {
        emit(PickSectionImageInitial());
        emit(SectionImagepicked(pickedImageModel: _image));
      }
      return;
    } catch (error) {
      emit(PickSectionImageInitial());

      if (error is PlatformException) {
        ShowSnackBar.showSnackBar(context, error.message ?? '');
      } else {
        ShowSnackBar.showSnackBar(context, error.toString());
      }
    }
  }

  Future<void> resetImage() async {
    emit(PickSectionImageInitial());
  }
}
