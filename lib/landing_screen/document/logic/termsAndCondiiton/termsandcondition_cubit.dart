import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service365_admin_panel/utility/document_picker.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';

part 'termsandcondition_state.dart';

class TermsandconditionCubit extends Cubit<TermsandconditionState> {
  TermsandconditionCubit() : super(TermsandconditionInitial());

  Future<void> pickTermsAndConditionDocument(
      {required BuildContext context}) async {
    try {
      final _aboutUsDocs = await PickDocument().pickDocument();
      if (_aboutUsDocs.selectedFile == null) {
        emit(TermsandconditionInitial());
        ShowSnackBar.showSnackBar(context, 'No file selected');
      } else {
        emit(TermsandconditionInitial());
        emit(TermsAndConditionPicked(pickedDocumentModel: _aboutUsDocs));
      }
      return;
    } catch (error) {
      emit(TermsandconditionInitial());

      if (error is PlatformException) {
        ShowSnackBar.showSnackBar(context, error.message ?? '');
      } else {
        ShowSnackBar.showSnackBar(context, error.toString());
      }
    }
  }

  Future<void> resetDocs() async {
    emit(TermsandconditionInitial());
  }
}
