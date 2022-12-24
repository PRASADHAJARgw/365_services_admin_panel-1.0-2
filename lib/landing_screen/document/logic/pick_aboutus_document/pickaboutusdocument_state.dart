part of 'pickaboutusdocument_cubit.dart';

abstract class PickaboutusdocumentState extends Equatable {
  const PickaboutusdocumentState();

  @override
  List<Object> get props => [];
}

class PickaboutusdocumentInitial extends PickaboutusdocumentState {}

class AboutUsDocsPicked extends PickaboutusdocumentState {
  final PickedDocumentModel pickedDocumentModel;
  const AboutUsDocsPicked({
    required this.pickedDocumentModel,
  });
}
