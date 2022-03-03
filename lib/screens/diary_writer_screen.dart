import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/Entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/src/widgets/text.dart' as Text;
import '../services/location_service.dart';
import 'activty_temp.dart';
import 'tabs/tab_1_main/home_main_tab.dart';
import 'package:path/path.dart' as Path;

class DiaryWriterScreen extends StatefulWidget {
  static const routeName = '/writer';

  const DiaryWriterScreen({Key? key}) : super(key: key);

  @override
  _DiaryWriterScreenState createState() => _DiaryWriterScreenState();
}

class _DiaryWriterScreenState extends State<DiaryWriterScreen> {
  var uuid = Uuid();
  late final QuillController _controller = QuillController(
    document: Document(),
    selection: const TextSelection.collapsed(offset: 0),
  );

  DateTime selectedEntryDate = DateTime.now();
  List<File> _images = [];
  bool isLoading = false;

  firebase_storage.Reference? ref;

  CollectionReference? imgRef;

  final ImagePicker picker = ImagePicker();

  List<String> _tempImageList = [];

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

  Future uploadImages() async {
    for (var img in _images) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');

      await ref!.putFile(img).whenComplete(
        () async {
          await ref!.getDownloadURL().then(
            (value) {
              _tempImageList.add(value);
              print(_tempImageList.length);
            },
          );
        },
      );
    }
  }

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

  var selectedMood = '';
  var selectedActivity = '';
  var place;

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
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.tag),
          ),
          PopupMenuButton(
            onSelected: (value) => setState(() {
              // selectedMood = value.toString();
              // print(selectedMood);
            }),
            icon: const Icon(Icons.my_location_rounded),
            // initialValue: 0,
            itemBuilder: (BuildContext bc) {
              return [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.location_on, color: Colors.black),
                      Text.Text(place == null
                          ? 'Current Location'
                          : '${place.locality}, ${place.country}'),
                    ],
                  ),
                  value: 'sad',
                  onTap: () async {
                    Position position = await Provider.of<LocationService>(
                            context,
                            listen: false)
                        .getLocationCoordinates();
                    Placemark location = await Provider.of<LocationService>(
                            context,
                            listen: false)
                        .getAddressFromCoordinates(position);
                    place = location;
                    print(place.country);
                  },
                ),
              ];
            },
          ),
          // IconButton(

          //   onPressed: () async {
          //     Position position =
          //         await Provider.of<LocationService>(context, listen: false)
          //             .getLocationCoordinates();
          //     Placemark location =
          //         await Provider.of<LocationService>(context, listen: false)
          //             .getAddressFromCoordinates(position);
          //     place = location;
          //     print(place.country);
          //   },
          //   icon: Icon(Icons.my_location_sharp),
          // ),
          _images.isNotEmpty
              ? Badge(
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
                        setState(() {
                          _displayImagePicker(context, _images, chooseImages);
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
                      final pickedImages =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedImages != null) {
                        setState(() {
                          _images.add(File(pickedImages.path));
                        });
                      }
                    } else {
                      setState(() {
                        _displayImagePicker(context, _images, chooseImages);
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
                    await uploadImages().whenComplete(
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
                                  location: place == null
                                      ? 'null'
                                      : '${place.locality}, ${place.country}',
                                  mood: selectedMood,
                                  image_list: _tempImageList,
                                  position: selectedActivity)
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
                      child: PopupMenuButton(
                        onSelected: (value) => setState(() {
                          selectedActivity = value.toString();
                          print(selectedActivity);
                        }),
                        icon: const Icon(Icons.accessibility_new),
                        // initialValue: 0,
                        itemBuilder: (BuildContext bc) {
                          return [
                            PopupMenuItem(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.directions_walk),
                                  Text.Text('Walking'),
                                ],
                              ),
                              value: 'Walking',
                            ),
                            PopupMenuItem(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.chair),
                                  Text.Text('Sitting'),
                                ],
                              ),
                              value: 'Sitting',
                            ),
                            PopupMenuItem(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.boy_outlined),
                                  Text.Text('Standing'),
                                ],
                              ),
                              value: 'Standing',
                            ),
                            PopupMenuItem(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.hotel),
                                  Text.Text('Nap'),
                                ],
                              ),
                              value: 'Nap',
                            ),
                            PopupMenuItem(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.auto_fix_high),
                                  Text.Text('Auto Detect'),
                                ],
                              ),
                              // value: 'average',
                            ),
                          ];
                        },
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
                      child: PopupMenuButton(
                        onSelected: (value) => setState(() {
                          selectedMood = value.toString();
                          print(selectedMood);
                        }),
                        icon: const Icon(Icons.mood),
                        // initialValue: 0,
                        itemBuilder: (BuildContext bc) {
                          return [
                            PopupMenuItem(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.sentiment_very_satisfied_outlined),
                                  Text.Text('Happy'),
                                ],
                              ),
                              value: 'Happy',
                            ),
                            PopupMenuItem(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.sentiment_dissatisfied_sharp),
                                  Text.Text('     Sad'),
                                ],
                              ),
                              value: 'Sad',
                            ),
                            PopupMenuItem(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.sentiment_neutral_outlined),
                                  Text.Text('Average'),
                                ],
                              ),
                              value: 'Average',
                            )
                          ];
                        },
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

_displayImagePicker(BuildContext context, _images, chooseImages) async {
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
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
                    : GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            // _images.removeAt(index - 1);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                _images[index - 1],
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
              child: Text.Text('Done'),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            )
          ],
        ),
      );
    },
  );
}
