import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firestore_service.dart';
import '../../models/Entry.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageDeleteAlertDialog extends StatelessWidget {
  String selectedImage;

  ImageDeleteAlertDialog({
    Key? key,
    required this.selectedImage,
    // required this.
  }) : super(key: key);

  // String selectedImage;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Image?'),
      content: const Text('Image will be Permenantly Deleted!'),
      actions: [
        TextButton(
            child: const Text('Abort'),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop()),
        TextButton(
          child: const Text('Delete'),
          onPressed: () async {
            print(selectedImage);
            await firebase_storage.FirebaseStorage.instance
                .refFromURL(selectedImage)
                .delete()
                .whenComplete(() => print('Image Deleted'));
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}
