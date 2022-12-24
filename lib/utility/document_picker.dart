import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class PickDocument {
  Future<PickedDocumentModel> pickDocument() async {
    try {
      var _pickedFileList = await FilePickerWeb.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (_pickedFileList == null) {
        return PickedDocumentModel(selectedFile: null);
      } else {
        //
        File _pickedFile = File(_pickedFileList.files.first.name);
        final _changeToByte = _pickedFileList.files.first.bytes;
        return PickedDocumentModel(
          selectedFile: _pickedFile,
          readAsBytes: _changeToByte,
        );
      }
    } on PlatformException {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }
}

class PickedDocumentModel {
  File? selectedFile;
  Uint8List? readAsBytes;
  PickedDocumentModel({
    this.selectedFile,
    this.readAsBytes,
  });
}
