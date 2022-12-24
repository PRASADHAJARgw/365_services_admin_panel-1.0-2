part of 'section_management_cubit.dart';

abstract class SectionmanagementState extends Equatable {
  const SectionmanagementState();

  @override
  List<Object> get props => [];
}

class SectionmanagementInitial extends SectionmanagementState {}

class ShowSectionLoadingSpinner extends SectionmanagementState {}
