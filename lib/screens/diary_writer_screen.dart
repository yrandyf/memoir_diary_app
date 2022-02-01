import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../models/Entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/src/widgets/text.dart' as Text;
import 'add_photos.dart';
import 'home_main_tab.dart';

class DiaryWriterScreen extends StatefulWidget {
  static const routeName = '/writer';

  const DiaryWriterScreen({Key? key}) : super(key: key);

  @override
  _DiaryWriterScreenState createState() => _DiaryWriterScreenState();
}

class _DiaryWriterScreenState extends State<DiaryWriterScreen> {
  late final QuillController _controller = QuillController(
    document: Document(),
    selection: const TextSelection.collapsed(offset: 0),
  );

  DateTime selectedEntryDate = DateTime.now();

  List<File> _images = [];

  final ImagePicker picker = ImagePicker();

  chooseImages() async {
    final pickedImages = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImages == null) {
        return;
      } else {
        _images.add(File(pickedImages.path));
        Navigator.of(context).pop();
      }
    });
    if (pickedImages?.path == null) retrieveLostData();
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

  _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedEntryDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selectedDate != null && selectedDate != selectedEntryDate)
      setState(
        () {
          selectedEntryDate = selectedDate;
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () {
            _selectDate(context);
          },
          child: Text.Text(
            '${selectedEntryDate.day}/${selectedEntryDate.month}/${selectedEntryDate.year}',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.my_location_sharp),
          ),
          Badge(
            badgeColor: Colors.white70,
            badgeContent: (Text.Text('${_images.length}')),
            position: BadgePosition.topEnd(top: 0, end: 0),
            child: IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () async {
                if (_images.isEmpty) {
                  final pickedImages =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _images.add(File(pickedImages!.path));
                  });
                } else {
                  _displayDialog(context, _images, chooseImages);
                }

                print(_images);
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('entries')
                  .add(
                    Entry(
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            date: selectedEntryDate,
                            content: _controller.document.toDelta().toJson(),
                            contentSummery:
                                _controller.plainTextEditingValue.text,
                            timeStamp: Timestamp.now(),
                            entryId: '356456',
                            location: 'panadura',
                            mood: 'happy',
                            photos: 'working on it',
                            position: 'sitting')
                        .toMap(),
                  )
                  .then((_) => Navigator.of(context).pop());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  reverse: true,
                  child: QuillEditor(
                    controller: _controller,
                    readOnly: false,
                    scrollController: ScrollController(),
                    scrollable: true,
                    focusNode: FocusNode(),
                    autoFocus: true,
                    expands: false,
                    maxHeight: null,
                    minHeight: null,
                    padding: EdgeInsets.zero,
                    placeholder: 'How was your day?',
                    showCursor: true,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(
                    top: 35,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: QuillToolbar.basic(
                    toolbarIconSize: 25,
                    toolbarSectionSpacing: 10,
                    controller: _controller,
                    // showDividers: false,
                    showSmallButton: false,
                    showInlineCode: false,
                    showColorButton: false,
                    showBackgroundColorButton: false,
                    showClearFormat: false,
                    // showHeaderStyle: false,
                    // showListNumbers: false,
                    // showListCheck: false,
                    showCodeBlock: false,
                    // showIndent: false,
                    showLink: false,
                    // showHistory: false,
                    multiRowsDisplay: false,
                    showImageButton: false,
                    showVideoButton: false,
                    showCameraButton: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_displayDialog(BuildContext context, _images, chooseImages) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text.Text('Add Images to your Diary Entry'),
        content: Container(
          width: MediaQuery.of(context).size.width * .9,
          child: GridView.builder(
            shrinkWrap: true,
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
        ),
        actions: <Widget>[
          new TextButton(
            child: new Text.Text('Done'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
