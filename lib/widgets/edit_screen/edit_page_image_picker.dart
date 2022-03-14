import 'dart:io';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import '../../services/entry_data_service.dart';
import 'delete_image.dart';

editPageImagePicker(BuildContext context, _tempImageList) async {
  final ImagePicker picker = ImagePicker();
  bool isLoading = false;
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Images to Your Entry'),
          content: Container(
            width: MediaQuery.of(context).size.width * .9,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: _tempImageList.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.blueGrey)
                            : IconButton(
                                icon: const Icon(Icons.add_a_photo_rounded),
                                onPressed: () async {
                                  final pickedImages = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  final File image;

                                  if (pickedImages == null) {
                                    return;
                                  } else {
                                    image = File(pickedImages.path);
                                    print(image);
                                  }

                                  var ref = firebase_storage
                                      .FirebaseStorage.instance
                                      .ref()
                                      .child(
                                          'images/${Path.basename(image.path)}');
                                  setState(() => isLoading = true);
                                  await ref.putFile(image).whenComplete(
                                    () async {
                                      await ref.getDownloadURL().then(
                                        (imageLink) {
                                          _tempImageList.add(imageLink);
                                          print(_tempImageList);
                                          Provider.of<EntryBuilderService>(
                                                  context,
                                                  listen: false)
                                              .setImageList(_tempImageList);
                                          setState(() => isLoading = false);
                                        },
                                      );
                                    },
                                  );
                                  setState(() {});
                                },
                              ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          String selectedImage = _tempImageList[index - 1];
                          setState(
                            () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ImageDeleteAlertDialog(
                                      selectedImage: selectedImage);
                                },
                              );
                              _tempImageList!.removeAt(index - 1);
                              Provider.of<EntryBuilderService>(context,
                                      listen: false)
                                  .setImageList(_tempImageList);
                            },
                          );
                        },
                        child: Badge(
                          badgeColor: Colors.red,
                          badgeContent: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 10,
                          ),
                          position: BadgePosition.topStart(top: 0, start: 0),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                scale: 0.5,
                                fit: BoxFit.cover,
                                image: NetworkImage(_tempImageList[index - 1]),
                              ),
                            ),
                          ),
                        ),
                      );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                setState(() => Navigator.of(context).pop());
              },
            )
          ],
        ),
      );
    },
  );
}
