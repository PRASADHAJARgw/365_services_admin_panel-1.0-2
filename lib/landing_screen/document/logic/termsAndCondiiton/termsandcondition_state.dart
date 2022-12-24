part of 'termsandcondition_cubit.dart';

abstract class TermsandconditionState extends Equatable {
  const TermsandconditionState();

  @override
  List<Object> get props => [];
}

class TermsandconditionInitial extends TermsandconditionState {}

class TermsAndConditionPicked extends TermsandconditionState {
  final PickedDocumentModel pickedDocumentModel;
  const TermsAndConditionPicked({
    required this.pickedDocumentModel,
  });
}
