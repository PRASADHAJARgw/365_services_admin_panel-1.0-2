import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service365_admin_panel/config/firebase_table_name.dart';
import 'package:service365_admin_panel/landing_screen/service_management/model/city_model.dart';

class CityRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addCityToFirebase({
    required CityModel city,
  }) async {
    final _cityDocs = _firebaseFirestore.collection(FirebasePath.city).doc();
    await _firebaseFirestore
        .collection(FirebasePath.city)
        .doc(_cityDocs.id)
        .set(city.toMap(cityId: _cityDocs.id));
    return;
  }

  Future<void> deleteCityFromFirebase({required CityModel cityModel}) async {
    await _firebaseFirestore
        .collection(FirebasePath.city)
        .doc(cityModel.id)
        .delete();
    return;
  }

  Future<void> deleteSelectedServicefromCity({
    required CityModel cityModel,
    required int serviceIndex,
  }) async {
    await _firebaseFirestore
        .collection(FirebasePath.city)
        .doc(cityModel.id)
        .update({
      'availableServices': FieldValue.arrayRemove(
        [cityModel.availableServices[serviceIndex].toMap()],
      )
    });
    return;
  }

  Future<void> editCity({required CityModel cityModel}) async {
    await _firebaseFirestore
        .collection(FirebasePath.city)
        .doc(cityModel.id)
        .update(cityModel.toMap(cityId: cityModel.id!));
    return;
  }

  Stream<List<CityModel?>> streamCityLog() {
    try {
      return _firebaseFirestore.collection(FirebasePath.city).snapshots().map(
            (snaps) =>
                snaps.docs.map((doc) => CityModel.fromMap(doc.data())).toList(),
          );
    } catch (error) {
      rethrow;
    }
  }
}
