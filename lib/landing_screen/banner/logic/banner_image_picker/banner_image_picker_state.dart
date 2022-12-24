part of 'banner_image_picker_cubit.dart';

abstract class BannerImagePickerState extends Equatable {
  const BannerImagePickerState();

  @override
  List<Object> get props => [];
}

class PickBannerImageInitial extends BannerImagePickerState {}

class ShowSpinnerDuringImagePick extends BannerImagePickerState {}

class BannerImagepicked extends BannerImagePickerState {
  final PickedImageModel pickedImageModel;
  const BannerImagepicked({
    required this.pickedImageModel,
  });
}
