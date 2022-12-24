import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  Future<PickedImageModel> pickImageFromGallery() async {
    try {
      var _pickedImageXFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 30,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (_pickedImageXFile == null) {
        return PickedImageModel(selectedImage: null, selectedImageBytes: []);
      } else {
        //For upload image with http
        final List<int> _selectedFileBytes = [];
        //
        File _pickedImage = File(_pickedImageXFile.name);
        final _changeToByte = await _pickedImageXFile.readAsBytes();
        final _bytes = Uint8List.fromList(_changeToByte);
        for (var elements in _bytes) {
          _selectedFileBytes.add(elements);
        }
        return PickedImageModel(
          selectedImage: _pickedImage,
          selectedImageBytes: _selectedFileBytes,
          readAsBytes: _bytes,
        );
      }
    } on PlatformException {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }
}

class PickedImageModel {
  File? selectedImage;
  List<int>? selectedImageBytes;
  Uint8List? readAsBytes;
  PickedImageModel({
    this.selectedImage,
    this.selectedImageBytes,
    this.readAsBytes,
  });
}
