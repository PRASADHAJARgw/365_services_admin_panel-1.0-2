part of 'pick_service_image_cubit.dart';

abstract class PickServiceImageState extends Equatable {
  const PickServiceImageState();

  @override
  List<Object> get props => [];
}

class PickServiceImageInitial extends PickServiceImageState {}

class ShowSpinnerDuringImagePick extends PickServiceImageState {}

class ServiceImagepicked extends PickServiceImageState {
  final PickedImageModel pickedImageModel;
  const ServiceImagepicked({
    required this.pickedImageModel,
  });
}
