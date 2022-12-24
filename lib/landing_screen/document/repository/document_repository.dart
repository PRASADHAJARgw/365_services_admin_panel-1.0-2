import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:service365_admin_panel/config/firebase_table_name.dart';
import 'package:service365_admin_panel/landing_screen/document/model/document_model.dart';
import 'package:service365_admin_panel/utility/document_picker.dart';

class DocumentRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;
  Future<String> _uploadAboutUsDocs({
    required PickedDocumentModel pickedDocumentModel,
    required String aboutUsDocsId,
    required String firebaseDocumentPath,
  }) async {
    //image upload to firebase
    final _ref = FirebaseStorage.instance
        .ref()
        .child('documents')
        .child(firebaseDocumentPath)
        .child(aboutUsDocsId + '.pdf');
    await _ref.putData(pickedDocumentModel.readAsBytes!,
        SettableMetadata(contentType: 'application/pdf'));
    final _docsUrl = await _ref.getDownloadURL();
    return _docsUrl;
  }

  Future<void> addAboutUsDocsToFirebase({
    required DocumentModel documentModel,
    required PickedDocumentModel pickedDocument,
    required String firebaseDocumentPath,
  }) async {
    final _docs = _firebaseFirestore
        .collection(FirebasePath.documents)
        .doc(firebaseDocumentPath);
    final _docsUrl = await _uploadAboutUsDocs(
      pickedDocumentModel: pickedDocument,
      aboutUsDocsId: _docs.id,
      firebaseDocumentPath:firebaseDocumentPath,
    );
    await _docs.set(documentModel.toMap(documentUrl: _docsUrl));
    return;
  }

  Stream<DocumentModel?> streamAboutUsLog() {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.documents)
          .doc(FirebasePath.aboutUs)
          .snapshots()
          .map((snaps) => DocumentModel.fromMap(snaps.data()!));
    } catch (error) {
      // print('Error getting stream of service ${error.toString()}');
      rethrow;
    }
  }

  Stream<DocumentModel?> streamPrivacyPolicyLog() {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.documents)
          .doc(FirebasePath.privacyPolicy)
          .snapshots()
          .map((snaps) => DocumentModel.fromMap(snaps.data()!));
    } catch (error) {
      // print('Error getting stream of service ${error.toString()}');
      rethrow;
    }
  }
   Stream<DocumentModel?> streamTermsAndConditionLog() {
    try {
      return _firebaseFirestore
          .collection(FirebasePath.documents)
          .doc(FirebasePath.termsAndCondition)
          .snapshots()
          .map((snaps) => DocumentModel.fromMap(snaps.data()!));
    } catch (error) {
      // print('Error getting stream of service ${error.toString()}');
      rethrow;
    }
  }
}
