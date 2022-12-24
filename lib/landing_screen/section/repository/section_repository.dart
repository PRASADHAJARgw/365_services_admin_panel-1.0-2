import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:service365_admin_panel/config/firebase_table_name.dart';
import 'package:service365_admin_panel/landing_screen/banner/model/advertisement_model.dart';
import 'package:service365_admin_panel/landing_screen/section/model/section_image_model.dart';
import 'package:service365_admin_panel/utility/image_picker.dart';

class SectionRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addSectionToFirebase({
    required AdvertisementModel advertisementModel,
  }) async {
    final _sectionDocs = _firebaseFirestore.collection(FirebasePath.sections);
    final _sectionDocId = _sectionDocs.doc().id;
    advertisementModel.id = _sectionDocId;
    advertisementModel.createdAt = DateTime.now();
    await _sectionDocs.doc(_sectionDocId).set(advertisementModel.toMap());
    return;
  }

  Future<void> deleteSectionFromFirebase(
      {required AdvertisementModel advertisementModel}) async {
    await _firebaseFirestore
        .collection(FirebasePath.sections)
        .doc(advertisementModel.id)
        .delete();
    return;
  }

  Stream<List<AdvertisementModel?>> streamSectionsLog() {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.sections)
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

//Section section
  Future<String> _uploadSectionImage({
    required PickedImageModel sectionImage,
    required String sectionImageId,
    required String sectionName,
  }) async {
    //image upload to firebase
    final _ref = FirebaseStorage.instance
        .ref()
        .child(FirebasePath.sectionImages)
        .child(sectionName)
        .child(sectionImageId + '.jpg');
    await _ref.putData(
        sectionImage.readAsBytes!, SettableMetadata(contentType: 'image/jpeg'));
    final _imageUrl = await _ref.getDownloadURL();
    return _imageUrl;
  }

  Future<void> addSectionImageToFirebase({
    required AdvertisementModel advertisementModel,
    required PickedImageModel pickedImage,
    required String imageName,
  }) async {
    final _sectionDocs = _firebaseFirestore.collection(FirebasePath.sections);
    final _sectionImageDocId = _sectionDocs
        .doc(advertisementModel.id)
        .collection(FirebasePath.sectionImages)
        .doc()
        .id;
    final _imageUrl = await _uploadSectionImage(
      sectionImage: pickedImage,
      sectionImageId: _sectionImageDocId,
      sectionName: advertisementModel.name,
    );
    final _imageModel = SectionImageModel(
      name: imageName,
      id: _sectionImageDocId,
      imageUrl: _imageUrl,
      createdAt: DateTime.now(),
    );

    await _sectionDocs
        .doc(advertisementModel.id)
        .collection(FirebasePath.sectionImages)
        .doc(_sectionImageDocId)
        .set(_imageModel.toMap());
    return;
  }

  Stream<List<SectionImageModel?>> streamSectionImagesLog({
    required String sectionDocId,
  }) {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.sections)
          .doc(sectionDocId)
          .collection(FirebasePath.sectionImages)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snaps) => snaps.docs
              .map((doc) => SectionImageModel.fromMap(doc.data()))
              .toList());
    } catch (error) {
      // print('Error getting stream of service ${error.toString()}');
      rethrow;
    }
  }

  //DELETING

  //Delete file from storage.
  Future<void> _deleteSectionImage({
    required String sectionId,
    required String sectionName,
    required String sectionImageId,
  }) async {
    //image upload to firebase
    final _ref = FirebaseStorage.instance
        .ref()
        .child(FirebasePath.sectionImages)
        .child(sectionName)
        .child(sectionImageId + '.jpg');
    await _ref.delete();
    return;
  }

  //Delete field from sections docs.
  Future<void> deleteSectionImageFromFirebase({
    required AdvertisementModel advertisementModel,
    required String sectionImageId,
  }) async {
    await _deleteSectionImage(
      sectionId: advertisementModel.id!,
      sectionName: advertisementModel.name,
      sectionImageId: sectionImageId,
    );
    await _firebaseFirestore
        .collection(FirebasePath.sections)
        .doc(advertisementModel.id)
        .collection(FirebasePath.sectionImages)
        .doc(sectionImageId)
        .delete();
    return;
  }
}
