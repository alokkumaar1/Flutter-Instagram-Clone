import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PhotoPicker {
  final ImagePicker imagePicker = ImagePicker();
  final ImageSource imageSource = ImageSource.gallery;
  final int imageQuality = 100;
  Future<File?> pickProfilePicture() async {
    final pickedImage = await imagePicker.pickImage(
      source: imageSource,
      imageQuality: imageQuality,
    );
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }

  Future<File?> pickPostImage() async {
    final pickedImage = await imagePicker.pickImage(
      source: imageSource,
      imageQuality: imageQuality,
    );
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }
}
