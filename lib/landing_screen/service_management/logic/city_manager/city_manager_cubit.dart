import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:service365_admin_panel/landing_screen/service_management/model/city_model.dart';
import 'package:service365_admin_panel/landing_screen/service_management/model/service_model.dart';
import 'package:service365_admin_panel/landing_screen/service_management/repository/city_repository.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';
part 'city_manager_state.dart';

class CityManagerCubit extends Cubit<CityManagerState> {
  CityManagerCubit() : super(CityManagerInitial());
  final _cityRepository = CityRepository();

  // List<ServiceModel?> availableService = [];
  List<ServiceCheckListModel> availableServiceWithCheckList = [];
  Future<void> setServiceListFromStream(
      {required List<ServiceModel?> availableService}) async {
    //Clean the service list
    availableServiceWithCheckList.clear();
    //
    for (var service in availableService) {
      availableServiceWithCheckList
          .add(ServiceCheckListModel(service: service!));
    }
    return;
  }

  Future<void> checkUncheckService(
      {required int index, required bool isChecked}) async {
    availableServiceWithCheckList.elementAt(index).isChecked = isChecked;
  }

  Future<void> uncheckTheServiceList() async {
    for (var element in availableServiceWithCheckList) {
      element.isChecked = false;
    }
    return;
  }

  Future<void> addCity(
      {required BuildContext context, required String cityName}) async {
    emit(ShowLoadingSpinnerofCity());
    try {
      List<ServiceModel> _selectedServices = [];
      for (var service in availableServiceWithCheckList
          .where((element) => element.isChecked)
          .toList()) {
        _selectedServices.add(service.service);
      }
      final _city =
          CityModel(cityName: cityName, availableServices: _selectedServices);
      await _cityRepository.addCityToFirebase(city: _city);
      emit(CityManagerInitial());

      ShowSnackBar.showSnackBar(
        context,
        "$cityName successfully added to city",
        textAlign: TextAlign.center,
      );
      await uncheckTheServiceList();
      return;
    } catch (e) {
      emit(CityManagerInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Unable to add to city",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Future<void> editCity({
    required BuildContext context,
    required CityModel cityModel,
    required bool isNameChanged,
  }) async {
    emit(ShowLoadingSpinnerofCity());
    try {
      // if (cityModel.availableServices.contains(serviceChecked.service.id)) {
      //   ShowSnackBar.showSnackBar(
      //     context,
      //     "Can't add same service again",
      //     textAlign: TextAlign.center,
      //   );
      //   return;

      List<ServiceModel> _selectedServices = [];
      for (var serviceChecked in availableServiceWithCheckList
          .where((element) => element.isChecked)
          .toList()) {
        bool _allow = true;
        for (var selectedService in cityModel.availableServices) {
          if (selectedService.id == serviceChecked.service.id) {
            _allow = false;
            break;
          }
        }
        if (_allow) {
          _selectedServices.add(serviceChecked.service);
        }
      }

      cityModel.availableServices
          .insertAll(cityModel.availableServices.length, _selectedServices);

      await _cityRepository.editCity(cityModel: cityModel);
      emit(CityManagerInitial());
      ShowSnackBar.showSnackBar(
        context,
        isNameChanged
            ? "City name changed to ${cityModel.cityName} successfully"
            : "City updated successfully",
        textAlign: TextAlign.center,
      );
      await uncheckTheServiceList();
      return;
    } catch (e) {
      emit(CityManagerInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Unable to edit '${cityModel.cityName}'",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Future<void> deleteSelectedService({
    required BuildContext context,
    required CityModel cityModel,
    required int serviceIndex,
  }) async {
    try {
      await _cityRepository.deleteSelectedServicefromCity(
        cityModel: cityModel,
        serviceIndex: serviceIndex,
      );
      //Remove the service from the loaded object also
      // cityModel.availableServices.removeAt(serviceIndex);
      ShowSnackBar.showSnackBar(
        context,
        "'${cityModel.availableServices[serviceIndex].serviceName}' successfully deleted",
        textAlign: TextAlign.center,
      );
      await uncheckTheServiceList();

      return;
    } catch (e) {
      ShowSnackBar.showSnackBar(
        context,
        "Unable to delete '${cityModel.availableServices[serviceIndex].serviceName}'",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Future<void> deleteCity({
    required BuildContext context,
    required CityModel cityModel,
  }) async {
    emit(ShowLoadingSpinnerofCity());
    try {
      await _cityRepository.deleteCityFromFirebase(
        cityModel: cityModel,
      );
      emit(CityManagerInitial());
      ShowSnackBar.showSnackBar(
        context,
        "'${cityModel.cityName}' successfully deleted",
        textAlign: TextAlign.center,
      );
      await uncheckTheServiceList();

      return;
    } catch (e) {
      emit(CityManagerInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Unable to delete '${cityModel.cityName}'",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Stream<List<CityModel?>> fetchCity({required BuildContext context}) {
    return _cityRepository.streamCityLog();
  }
}
