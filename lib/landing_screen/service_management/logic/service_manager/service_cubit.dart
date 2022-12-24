import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:service365_admin_panel/landing_screen/service_management/model/service_model.dart';
import 'package:service365_admin_panel/landing_screen/service_management/repository/service_repository.dart';
import 'package:service365_admin_panel/utility/image_picker.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';
part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit() : super(ServiceInitial());

  final _serviceRepository = ServiceRepository();

  Future<void> addService({
    required BuildContext context,
    required ServiceModel service,
    required PickedImageModel pickedImage,
  }) async {
    emit(ShowLoadingSpinner());
    try {
      await _serviceRepository.addServiceToFirebase(
        service: service,
        pickedImage: pickedImage,
      );
      emit(ServiceInitial());

      ShowSnackBar.showSnackBar(
        context,
        "'${service.serviceName}' successfully added to service",
        textAlign: TextAlign.center,
      );
      return;
    } catch (e) {
      emit(ServiceInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Unable to add '${service.serviceName}' to service",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Future<void> editService({
    required BuildContext context,
    required ServiceModel service,
    PickedImageModel? pickedImage,
  }) async {
    emit(ShowLoadingSpinner());

    try {
      await _serviceRepository.editServiceToFirebase(
        service: service,
        pickedImage: pickedImage,
      );
      emit(ServiceInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Service name changed to '${service.serviceName}' successfully",
        textAlign: TextAlign.center,
      );
      return;
    } catch (e) {
      emit(ServiceInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Unable to edit '${service.serviceName}'",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Future<void> deleteService(
      {required BuildContext context, required ServiceModel service}) async {
    emit(ShowLoadingSpinner());
    try {
      await _serviceRepository.deleteServiceFromFirebase(
        service: service,
      );
      emit(ServiceInitial());
      ShowSnackBar.showSnackBar(
        context,
        "'${service.serviceName}' successfully deleted",
        textAlign: TextAlign.center,
      );
      return;
    } catch (e) {
      emit(ServiceInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Unable to delete '${service.serviceName}'",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Stream<List<ServiceModel?>> fetchService({required BuildContext context}) {
    return _serviceRepository.streamServiceLog();
  }
}
