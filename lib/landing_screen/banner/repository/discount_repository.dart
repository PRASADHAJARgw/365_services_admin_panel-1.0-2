import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:service365_admin_panel/config/firebase_table_name.dart';
import 'package:service365_admin_panel/landing_screen/banner/model/advertisement_model.dart';
import 'package:service365_admin_panel/utility/image_picker.dart';

class DiscountRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;

//discount section

  Future<String> _uploaddiscountImage({
    required PickedImageModel discountImage,
    required String discountId,
  }) async {
    //image upload to firebase
    final _ref = FirebaseStorage.instance
        .ref()
        .child('discount_images')
        .child(discountId + '.jpg');
    await _ref.putData(discountImage.readAsBytes!,
        SettableMetadata(contentType: 'image/jpeg'));
    final _imageUrl = await _ref.getDownloadURL();
    return _imageUrl;
  }

  Future<void> _deletediscountImage({
    required String discountId,
  }) async {
    //image upload to firebase
    final _ref = FirebaseStorage.instance
        .ref()
        .child('discount_images')
        .child(discountId + '.jpg');
    await _ref.delete();
    return;
  }

  Future<void> adddiscountToFirebase({
    required AdvertisementModel advertisementModel,
    required PickedImageModel pickedImage,
  }) async {
    final discountDocs = _firebaseFirestore.collection(FirebasePath.discount);
    final discountDocId = discountDocs.doc().id;
    final _imageUrl = await _uploaddiscountImage(
      discountImage: pickedImage,
      discountId: discountDocId,
    );
    advertisementModel.id = discountDocId;
    advertisementModel.imageUrl = _imageUrl;
    advertisementModel.createdAt = DateTime.now();

    await discountDocs.doc(discountDocId).set(advertisementModel.toMap());
    return;
  }

  Future<void> deletediscountFromFirebase(
      {required AdvertisementModel advertisementModel}) async {
    await _deletediscountImage(discountId: advertisementModel.id!);
    await _firebaseFirestore
        .collection(FirebasePath.discount)
        .doc(advertisementModel.id)
        .delete();
    return;
  }

  Stream<List<AdvertisementModel?>> streamdiscountLog() {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.discount)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snaps) => snaps.docs
              .map((doc) => AdvertisementModel.fromMap(doc.data()))
              .toList());
    } catch (error) {
      // print('Error getting stream of service ${error.toString()}');
      rethrow;
    }
  }

//advertisement section

  Future<String> _uploadAdvImage({
    required PickedImageModel advImage,
    required String advId,
  }) async {
    //image upload to firebase
    final _ref = FirebaseStorage.instance
        .ref()
        .child('adv_images')
        .child(advId + '.jpg');
    await _ref.putData(
        advImage.readAsBytes!, SettableMetadata(contentType: 'image/jpeg'));
    final _imageUrl = await _ref.getDownloadURL();
    return _imageUrl;
  }

  Future<void> _deleteAdvImage({
    required String advId,
  }) async {
    //image upload to firebase
    final _ref = FirebaseStorage.instance
        .ref()
        .child('adv_images')
        .child(advId + '.jpg');
    await _ref.delete();
    return;
  }

  Future<void> addAdvToFirebase({
    required AdvertisementModel advModel,
    required PickedImageModel pickedImage,
  }) async {
    final _advDocs = _firebaseFirestore.collection(FirebasePath.adv);
    final _advDocId = _advDocs.doc().id;

    final _imageUrl = await _uploadAdvImage(
      advImage: pickedImage,
      advId: _advDocId,
    );
    advModel.id = _advDocId;
    advModel.imageUrl = _imageUrl;
    advModel.createdAt = DateTime.now();
    await _advDocs.doc(_advDocId).set(advModel.toMap());
    return;
  }

  Future<void> deleteAdvFromFirebase(
      {required AdvertisementModel advertisementModel}) async {
    await _deleteAdvImage(advId: advertisementModel.id!);
    await _firebaseFirestore
        .collection(FirebasePath.adv)
        .doc(advertisementModel.id)
        .delete();
    return;
  }

  Stream<List<AdvertisementModel?>> streamAdvLog() {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.adv)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snaps) => snaps.docs
              .map((doc) => AdvertisementModel.fromMap(doc.data()))
              .toList());
    } catch (error) {
      // print('Error getting stream of service ${error.toString()}');
      rethrow;
    }
  }
}
