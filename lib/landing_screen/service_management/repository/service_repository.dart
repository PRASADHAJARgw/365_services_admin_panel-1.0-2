import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:service365_admin_panel/config/firebase_table_name.dart';
import 'package:service365_admin_panel/landing_screen/service_management/model/city_model.dart';
import 'package:service365_admin_panel/landing_screen/service_management/model/service_model.dart';
import 'package:service365_admin_panel/utility/image_picker.dart';

class ServiceRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;
  Future<String> _uploadServiceImage({
    required PickedImageModel serviceImage,
    required String serviceId,
  }) async {
    //image upload to firebase
    final _ref = FirebaseStorage.instance
        .ref()
        .child('service_images')
        .child(serviceId + '.jpg');
    await _ref.putData(
        serviceImage.readAsBytes!, SettableMetadata(contentType: 'image/jpeg'));
    final _imageUrl = await _ref.getDownloadURL();
    return _imageUrl;
  }

  Future<void> _deleteServiceImage({
    required String serviceId,
  }) async {
    //image upload to firebase
    final _ref = FirebaseStorage.instance
        .ref()
        .child('service_images')
        .child(serviceId + '.jpg');
    await _ref.delete();
    return;
  }

  Future<void> addServiceToFirebase({
    required ServiceModel service,
    required PickedImageModel pickedImage,
  }) async {
    // print('Service');
    // print(service.serviceName);
    final _serviceDocs =
        _firebaseFirestore.collection(FirebasePath.service).doc();

    final _imageUrl = await _uploadServiceImage(
      serviceImage: pickedImage,
      serviceId: _serviceDocs.id,
    );
    service.imageUrl = _imageUrl;
    service.id = _serviceDocs.id;
    await _firebaseFirestore
        .collection(FirebasePath.service)
        .doc(_serviceDocs.id)
        .set(service.toMap());
    return;
  }

  Future<void> deleteServiceFromFirebase(
      {required ServiceModel service}) async {
    await _deleteServiceImage(serviceId: service.id!);
    await _firebaseFirestore
        .collection(FirebasePath.service)
        .doc(service.id)
        .delete();
    return;
  }

  Future<List<CityModel>> fetchAvailableCity() async =>
      await _firebaseFirestore.collection(FirebasePath.city).get().then(
            (response) => response.docs
                .map((doc) => CityModel.fromMap(doc.data()))
                .toList(),
          );
  Future<void> editServiceToFirebase({
    required ServiceModel service,
    PickedImageModel? pickedImage,
  }) async {
    String? _imageUrl;
    if (pickedImage != null) {
      _imageUrl = await _uploadServiceImage(
        serviceImage: pickedImage,
        serviceId: service.id!,
      );
      service.imageUrl = _imageUrl;
    }
    await _firebaseFirestore
        .collection(FirebasePath.service)
        .doc(service.id)
        .update(
          service.toMap(),
        );

    final _cityList = await fetchAvailableCity();
    if (_cityList.isNotEmpty) {
    //Update the service details accross the city.
      for (var city in _cityList) {
        for (var servicemodel in city.availableServices) {
          bool _updateData = false;
          if (servicemodel.id == service.id &&
              servicemodel.imageUrl != service.imageUrl) {
            servicemodel.imageUrl = service.imageUrl;
            _updateData = true;
          }
          if (servicemodel.id == service.id &&
              servicemodel.serviceName != service.serviceName) {
            servicemodel.serviceName = service.serviceName;
            _updateData = true;
          }
          if (_updateData) {
            _firebaseFirestore
                .collection(FirebasePath.city)
                .doc(city.id)
                .update(city.toMap(cityId: city.id!));
          }
        }
      }
    }
    return;
  }

  Stream<List<ServiceModel?>> streamServiceLog() {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.service)
          .snapshots()
          .map((snaps) => snaps.docs
              .map((doc) => ServiceModel.fromMap(doc.data()))
              .toList());
    } catch (error) {
      // print('Error getting stream of service ${error.toString()}');
      rethrow;
    }
  }
}
