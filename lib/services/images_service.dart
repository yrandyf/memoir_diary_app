import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImagesService extends ChangeNotifier {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  firebase_storage.Reference? ref;
  List<String> tempImageList = [];

  chooseImages() async {
    final pickedImages = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImages == null) {
      return;
    } else {
      images.add(File(pickedImages.path));
      notifyListeners();
    }
    if (pickedImages.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      images.add(File(response.file!.path));
      notifyListeners();
    } else {
      print(response.file);
    }
  }

  Future uploadImages() async {
    for (var img in images) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');

      await ref!.putFile(img).whenComplete(
        () async {
          await ref!.getDownloadURL().then(
            (value) {
              tempImageList.add(value);
              notifyListeners();
              print(tempImageList.length);
            },
          );
        },
      );
    }
  }
}
