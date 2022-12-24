import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service365_admin_panel/config/firebase_table_name.dart';
import 'package:service365_admin_panel/landing_screen/document/logic/TermsAndCondiiton/termsandcondition_cubit.dart';
import 'package:service365_admin_panel/landing_screen/document/logic/pick_aboutus_document/pickaboutusdocument_cubit.dart';
import 'package:service365_admin_panel/landing_screen/document/logic/pick_privacypolicy/pickprivacypolicy_cubit.dart';
import 'package:service365_admin_panel/landing_screen/document/model/document_model.dart';
import 'package:service365_admin_panel/landing_screen/document/repository/document_repository.dart';
import 'package:service365_admin_panel/utility/document_picker.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';
part 'documentmanager_state.dart';

class DocumentmanagerCubit extends Cubit<DocumentmanagerState> {
  DocumentmanagerCubit() : super(DocumentmanagerInitial());

  final _documentRepository = DocumentRepository();

  Future<void> addDocument({
    required BuildContext context,
    required DocumentModel documentModel,
    required PickedDocumentModel pickedDocumentModel,
    required String firebaseDocumentPath,
  }) async {
    emit(ShowDocsLoadingSpinner());
    try {
      await _documentRepository.addAboutUsDocsToFirebase(
        documentModel: documentModel,
        pickedDocument: pickedDocumentModel,
        firebaseDocumentPath: firebaseDocumentPath,
      );
      switch (firebaseDocumentPath) {
        case FirebasePath.aboutUs:
          BlocProvider.of<PickaboutusdocumentCubit>(context).resetDocs();
          break;
        case FirebasePath.privacyPolicy:
          BlocProvider.of<PickprivacypolicyCubit>(context).resetDocs();
          break;
        default:
          BlocProvider.of<TermsandconditionCubit>(context).resetDocs();
          break;
      }
      emit(DocumentmanagerInitial());
      ShowSnackBar.showSnackBar(
        context,
        "'${documentModel.documentName}' successfully added",
        textAlign: TextAlign.center,
      );
      return;
    } catch (e) {
      emit(DocumentmanagerInitial());
      ShowSnackBar.showSnackBar(
        context,
        "Unable to add '${documentModel.documentName}'",
        textAlign: TextAlign.center,
      );
      return;
    }
  }

  Stream<DocumentModel?> fetchAboutUsDocs() {
    return _documentRepository.streamAboutUsLog();
  }

  Stream<DocumentModel?> fetchPrivacyPolicyDocs() {
    return _documentRepository.streamPrivacyPolicyLog();
  }
    Stream<DocumentModel?> fetchTermsAndConditionDocs() {
    return _documentRepository.streamTermsAndConditionLog();
  }
}
