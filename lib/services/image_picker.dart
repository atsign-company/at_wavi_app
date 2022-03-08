import 'dart:typed_data';
import 'package:at_location_flutter/utils/constants/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';

class ImagePicker {
  ImagePicker._();
  static final ImagePicker _instance = ImagePicker._();
  factory ImagePicker() => _instance;

  Future<Uint8List?> pickImage() async {
    Uint8List? fileContents;
    // ignore: omit_local_variable_types
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null) {
      for (var pickedFile in result.files) {
        // var path = pickedFile.path;
        // var file = File(path);

        var _cropped = await ImageCropper().cropImage(
            sourcePath: pickedFile.path!,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            compressQuality: 100,
            maxHeight: 700,
            maxWidth: 700,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
                toolbarColor: AllColors().WHITE,
                toolbarTitle: 'Cropper',
                statusBarColor: AllColors().DARK_GREY,
                backgroundColor: AllColors().WHITE));

        if (_cropped == null) {
          return null;
        }

        var compressedFile = await FlutterImageCompress.compressWithFile(
          _cropped.path,
          minWidth: 400,
          minHeight: 200,
        );
        fileContents = compressedFile;
      }
    }
    return fileContents;
  }
}
