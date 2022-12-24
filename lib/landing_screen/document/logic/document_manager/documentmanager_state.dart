part of 'documentmanager_cubit.dart';

abstract class DocumentmanagerState extends Equatable {
  const DocumentmanagerState();

  @override
  List<Object> get props => [];
}

class DocumentmanagerInitial extends DocumentmanagerState {}

class ShowDocsLoadingSpinner extends DocumentmanagerState {}
