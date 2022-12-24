import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service365_admin_panel/utility/document_picker.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';

part 'pickprivacypolicy_state.dart';

class PickprivacypolicyCubit extends Cubit<PickprivacypolicyState> {
  PickprivacypolicyCubit() : super(PickprivacypolicyInitial());

    Future<void> pickPrivacyPolicyDocument({required BuildContext context}) async {
    try {
      final _aboutUsDocs = await PickDocument().pickDocument();
      if (_aboutUsDocs.selectedFile == null) {
        emit(PickprivacypolicyInitial());
        ShowSnackBar.showSnackBar(context, 'No file selected');
      } else {
        emit(PickprivacypolicyInitial());
        emit(PrivacyPolicyPicked(pickedDocumentModel: _aboutUsDocs));
      }
      return;
    } catch (error) {
      emit(PickprivacypolicyInitial());

      if (error is PlatformException) {
        ShowSnackBar.showSnackBar(context, error.message ?? '');
      } else {
        ShowSnackBar.showSnackBar(context, error.toString());
      }
    }
  }

  Future<void> resetDocs() async {
    emit(PickprivacypolicyInitial());
  }
}
