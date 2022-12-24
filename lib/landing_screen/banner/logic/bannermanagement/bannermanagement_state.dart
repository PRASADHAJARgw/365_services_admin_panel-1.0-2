part of 'bannermanagement_cubit.dart';

abstract class BannerManagementState extends Equatable {
  const BannerManagementState();

  @override
  List<Object> get props => [];
}

class BannerManagementInitial extends BannerManagementState {}

class ShowBannerLoadingSpinner extends BannerManagementState {}
