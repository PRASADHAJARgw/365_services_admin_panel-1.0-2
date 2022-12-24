part of 'section_image_management_cubit.dart';

abstract class SectionImageManagementState extends Equatable {
  const SectionImageManagementState();

  @override
  List<Object> get props => [];
}

class SectionImageManagementInitial extends SectionImageManagementState {}

class SectionImageLoading extends SectionImageManagementState {}
