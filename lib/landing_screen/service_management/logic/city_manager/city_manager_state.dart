part of 'city_manager_cubit.dart';

abstract class CityManagerState extends Equatable {
  const CityManagerState();

  @override
  List<Object> get props => [];
}

class CityManagerInitial extends CityManagerState {}

class ShowLoadingSpinnerofCity extends CityManagerState {}
