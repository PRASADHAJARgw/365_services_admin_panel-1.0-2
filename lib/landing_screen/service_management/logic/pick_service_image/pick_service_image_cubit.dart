import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:service365_admin_panel/utility/image_picker.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';
part 'pick_service_image_state.dart';

class PickServiceImageCubit extends Cubit<PickServiceImageState> {
  PickServiceImageCubit() : super(PickServiceImageInitial());

  Future<void> pickServiceImage({required BuildContext context}) async {
    // emit(ShowSpinnerDuringImagePick());
    try {
      final _imageFile = await PickImage().pickImageFromGallery();
      if (_imageFile.selectedImage == null) {
        emit(PickServiceImageInitial());
        ShowSnackBar.showSnackBar(context, 'No image selected');
      } else {
        emit(PickServiceImageInitial());
        emit(ServiceImagepicked(pickedImageModel: _imageFile));
      }
      return;
    } catch (error) {
      emit(PickServiceImageInitial());

      if (error is PlatformException) {
        ShowSnackBar.showSnackBar(context, error.message ?? '');
      } else {
        ShowSnackBar.showSnackBar(context, error.toString());
      }
    }
  }

  Future<void> resetImage() async {
    emit(PickServiceImageInitial());
  }
}
