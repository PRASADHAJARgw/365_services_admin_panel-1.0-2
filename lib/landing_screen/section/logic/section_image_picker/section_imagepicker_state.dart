part of 'section_imagepicker_cubit.dart';

abstract class SectionImagePickerState extends Equatable {
  const SectionImagePickerState();

  @override
  List<Object> get props => [];
}

class PickSectionImageInitial extends SectionImagePickerState {}

class ShowSpinnerDuringSelectionImagePick extends SectionImagePickerState {}

class SectionImagepicked extends SectionImagePickerState {
  final PickedImageModel pickedImageModel;
  const SectionImagepicked({
    required this.pickedImageModel,
  });
}
