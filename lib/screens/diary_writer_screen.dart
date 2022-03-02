import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/Entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/src/widgets/text.dart' as Text;
import '../services/images_service.dart';
import '../widgets/image_picker.dart';

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

  bool isLoading = false;

  @override
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
    List<File> _images =
        Provider.of<ImagesService>(context, listen: false).images;
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () {
            _selectDate(context);
          },
          child: Text.Text(
            '${selectedEntryDate.day}/${selectedEntryDate.month}/${selectedEntryDate.year}',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.tag),
          ),
          IconButton(
            onPressed: () {
              // Navigator.of(context)
              // .pushReplacementNamed(ImagePickerScreen.routeName);
            },
            icon: Icon(Icons.my_location_sharp),
          ),
          _images.isNotEmpty
              ? Badge(
                  badgeColor: Colors.white70,
                  badgeContent: (Text.Text('${_images.length}')),
                  position: BadgePosition.topEnd(top: 0, end: 0),
                  child: IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () async {
                      if (_images.isEmpty) {
                        final pickedImages = await Provider.of<ImagesService>(
                                context,
                                listen: false)
                            .picker
                            .pickImage(source: ImageSource.gallery);
                        setState(() {
                          _images.add(File(pickedImages!.path));
                        });
                      } else {
                        setState(() {
                          displayImagePicker(
                            context,
                            _images,
                          );
                        });
                      }
                      print(_images);
                    },
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () async {
                    if (_images.isEmpty) {
                      final pickedImages = await Provider.of<ImagesService>(
                              context,
                              listen: false)
                          .picker
                          .pickImage(source: ImageSource.gallery);
                      if (pickedImages != null) {
                        setState(() {
                          _images.add(File(pickedImages.path));
                        });
                      }
                    } else {
                      setState(() {
                        displayImagePicker(
                          context,
                          _images,
                        );
                      });
                    }

                    print(_images);
                  },
                ),
          isLoading
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    CollectionReference? entryRef =
                        FirebaseFirestore.instance.collection('entries');
                    await Provider.of<ImagesService>(context, listen: false)
                        .uploadImages()
                        .whenComplete(
                      () async {
                        await entryRef
                            .add(
                          Entry(
                                  userId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  date: selectedEntryDate,
                                  content:
                                      _controller.document.toDelta().toJson(),
                                  contentSummery:
                                      _controller.plainTextEditingValue.text,
                                  timeStamp: Timestamp.now(),
                                  location: 'Panadura, Sri Lanka',
                                  mood: 'Happy',
                                  image_list: Provider.of<ImagesService>(
                                          context,
                                          listen: false)
                                      .tempImageList,
                                  position: 'Sitting')
                              .toMap(),
                        )
                            .whenComplete(
                          () {
                            Navigator.of(context).pop();
                            print('Entry Saved');
                          },
                        ).then((_) => isLoading = false);
                      },
                    );
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
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Card(
                      margin: const EdgeInsets.only(
                        top: 35,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.accessibility),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Card(
                      margin: const EdgeInsets.only(
                        top: 35,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.mood),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
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
            ],
          ),
        ),
      ),
    );
  }
}
