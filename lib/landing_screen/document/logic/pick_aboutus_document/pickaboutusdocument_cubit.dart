import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service365_admin_panel/utility/document_picker.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';
part 'pickaboutusdocument_state.dart';

class PickaboutusdocumentCubit extends Cubit<PickaboutusdocumentState> {
  PickaboutusdocumentCubit() : super(PickaboutusdocumentInitial());

  Future<void> pickAboutUsDocument({required BuildContext context}) async {
    try {
      final _aboutUsDocs = await PickDocument().pickDocument();
      if (_aboutUsDocs.selectedFile == null) {
        emit(PickaboutusdocumentInitial());
        ShowSnackBar.showSnackBar(context, 'No file selected');
      } else {
        emit(PickaboutusdocumentInitial());
        emit(AboutUsDocsPicked(pickedDocumentModel: _aboutUsDocs));
      }
      return;
    } catch (error) {
      emit(PickaboutusdocumentInitial());

      if (error is PlatformException) {
        ShowSnackBar.showSnackBar(context, error.message ?? '');
      } else {
        ShowSnackBar.showSnackBar(context, error.toString());
      }
    }
  }

  Future<void> resetDocs() async {
    emit(PickaboutusdocumentInitial());
  }
}
