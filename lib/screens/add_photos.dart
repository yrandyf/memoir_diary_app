import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class ImagePickerScreen extends StatefulWidget {
  static const routeName = '/mediapicker';
  const ImagePickerScreen({Key? key}) : super(key: key);

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  bool uploading = false;
  double val = 0;

  List<File> _images = [];

  final ImagePicker picker = ImagePicker();
  CollectionReference? imgRef;
  firebase_storage.Reference? ref;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Images to Entry"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                uploading = true;
              });
              uploadFile().whenComplete(() => Navigator.of(context).pop());
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GridView.builder(
            itemCount: _images.length + 1,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              return index == 0
                  ? Center(
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo_rounded),
                        onPressed: () {
                          chooseImages();
                        },
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(
                            _images[index - 1],
                          ),
                        ),
                      ),
                    );
            },
          ),
          uploading ? Center(child: CircularProgressIndicator()) : Container(),
        ],
      ),
    );
  }

  chooseImages() async {
    final pickedImages = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _images.add(File(pickedImages!.path));
    });
    if (pickedImages!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _images.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    for (var img in _images) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');

      await ref!.putFile(img).whenComplete(
        () async {
          await ref!.getDownloadURL().then(
            (value) {
              imgRef!.add({'url': value});
            },
          );
        },
      );
    }
  }

  @override
  void initState() {
    imgRef = FirebaseFirestore.instance.collection('imageURLs');
    super.initState();
  }
}
