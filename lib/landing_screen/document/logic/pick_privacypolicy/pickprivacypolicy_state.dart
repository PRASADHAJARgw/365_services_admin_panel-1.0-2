part of 'pickprivacypolicy_cubit.dart';

abstract class PickprivacypolicyState extends Equatable {
  const PickprivacypolicyState();

  @override
  List<Object> get props => [];
}

class PickprivacypolicyInitial extends PickprivacypolicyState {}

class PrivacyPolicyPicked extends PickprivacypolicyState {
  final PickedDocumentModel pickedDocumentModel;
  const PrivacyPolicyPicked({
    required this.pickedDocumentModel,
  });
}
