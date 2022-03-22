import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/Entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/src/widgets/text.dart' as Text;
import '../models/DropDownItem.dart';
import '../models/Tag.dart';
import '../services/entry_data_service.dart';
import '../services/firestore_service.dart';
import '../services/images_service.dart';
import '../services/location_service.dart';
import '../services/tag_Service.dart';
import '../widgets/image_picker.dart';
import '../widgets/location_sheet.dart';
import '../widgets/tag_sheet.dart';
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
  late final QuillController _controller = QuillController(
    document: Document(),
    selection: const TextSelection.collapsed(offset: 0),
  );

  DateTime selectedEntryDate = DateTime.now();
  bool isLoading = false;

  firebase_storage.Reference? ref;

  CollectionReference? imgRef;

  _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedEntryDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selectedDate != null && selectedDate != selectedEntryDate) {
      setState(
        () {
          selectedEntryDate = selectedDate;
        },
      );
    }
  }

  List<DropDownItems> moods = <DropDownItems>[
    DropDownItems('Happy', Icon(Icons.sentiment_very_satisfied_outlined)),
    DropDownItems('Sad', Icon(Icons.sentiment_dissatisfied_sharp)),
    DropDownItems('Average', Icon(Icons.sentiment_neutral_outlined)),
    DropDownItems(
        'Dissatisfied', Icon(Icons.sentiment_very_dissatisfied_outlined))
  ];
  List<DropDownItems> activities = <DropDownItems>[
    DropDownItems('Standing', Icon(Icons.boy_outlined)),
    DropDownItems('Walking', Icon(Icons.directions_walk)),
    DropDownItems('Sitting', Icon(Icons.chair)),
    DropDownItems('Nap', Icon(Icons.hotel)),
    DropDownItems('Auto Detect', Icon(Icons.auto_fix_high))
  ];

  DropDownItems? selectedMood;
  DropDownItems? selectedActivity;
  Placemark? place;
  Position? coordinates;

  List<File> _images = [];
  List<String> _tempImageList = [];
  CollectionReference? entryRef =
      FirebaseFirestore.instance.collection('entries');

  // final _formKey = GlobalKey<FormState>();

  _show(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 5,
      context: ctx,
      builder: (ctx) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Wrap(
                children: [
                  Form(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Form(
                        key: _formKey2,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: locationTextController,
                              decoration: InputDecoration(
                                labelText: 'Enter Location',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: () {},
                                ),
                              ),
                              validator: (value) {
                                if (_formKey2.currentState!.validate()) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter a Valid City';
                                  }
                                }
                              },
                            ),
                            const SizedBox(height: 15),
                            Text.Text(
                                place != null
                                    ? '${place?.locality}, ${place?.country}'
                                    : 'Select a Location',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 15),
                            IconButton(
                              icon: const Icon(
                                Icons.my_location,
                                size: 45,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                Position position =
                                    await Provider.of<LocationService>(context,
                                            listen: false)
                                        .getLocationCoordinates();
                                Placemark location =
                                    await Provider.of<LocationService>(context,
                                            listen: false)
                                        .getAddressFromCoordinates(position);
                                setState(() {
                                  coordinates = position;
                                  place = location;
                                  print(place?.country);
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<dynamic>? selectedTags = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final tagTextController = TextEditingController();
  final locationTextController = TextEditingController();
  List<String> tags = [];
  List tagSearchSugestions = [];

  Future getDocs() async {
    tagSearchSugestions = (await Provider.of<FirestoreService>(context,
                listen: false)
            .getSearch())
        .map((tags) {
          return Tag.fromDocument(tags);
        })
        .where(
            (entry) => entry.userId == FirebaseAuth.instance.currentUser!.uid)
        .toList();
    // print(tagSearchSugestions);
    setState(() {});
  }

  @override
  void initState() {
    getDocs();
    super.initState();
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
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tag),
            onPressed: () {
              tagModalSheet(
                context,
                _formKey,
                tagTextController,
                entryRef,
                tags,
                tagSearchSugestions,
              );
              print(tags);
            },
          ),
          IconButton(
              icon: const Icon(Icons.my_location_rounded),
              onPressed: () {
                print(place);
                _show(context);
              }),
          // PopupMenuButton(
          //   onSelected: (value) => setState(() {
          //     locationModalSheet(context);
          //   }),
          //   icon: const Icon(Icons.my_location_rounded),
          //   itemBuilder: (BuildContext bc) {
          //     return [
          //       PopupMenuItem(
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //           children: [
          //             Icon(Icons.location_on, color: Colors.black),
          //             Text.Text(place == null
          //                 ? 'Current Location'
          //                 : '${place.locality}, ${place.country}'),
          //           ],
          //         ),
          //         onTap: () async {
          //           locationModalSheet(context);
          //           // Position position = await Provider.of<LocationService>(
          //           //         context,
          //           //         listen: false)
          //           //     .getLocationCoordinates();
          //           // Placemark location = await Provider.of<LocationService>(
          //           //         context,
          //           //         listen: false)
          //           //     .getAddressFromCoordinates(position);
          //           // place = location;
          //           // print(place.country);
          //         },
          //       ),
          //     ];
          //   },
          // ),
          _images.isNotEmpty
              ? Badge(
                  badgeColor: Colors.white70,
                  badgeContent: (Text.Text('${_images.length}')),
                  position: BadgePosition.topEnd(top: 0, end: 0),
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo),
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
                        displayImagePicker(context, _images);
                        setState(() {});
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
                        _images.add(File(pickedImages.path));

                        setState(() {});
                      }
                    } else {
                      displayImagePicker(context, _images);
                      setState(() {});
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
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    await Provider.of<ImagesService>(context, listen: false)
                        .uploadImages(_images, _tempImageList)
                        .whenComplete(
                      () async {
                        await Provider.of<FirestoreService>(context,
                                listen: false)
                            .createEntry(Entry(
                                entryId: entryRef!.doc().id,
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                date: selectedEntryDate,
                                content:
                                    _controller.document.toDelta().toJson(),
                                contentSummery:
                                    _controller.plainTextEditingValue.text,
                                timeStamp: DateTime.now(),
                                location: place == null
                                    ? 'null'
                                    : '${place!.locality}, ${place!.country}',
                                mood: selectedMood?.name,
                                image_list: _tempImageList,
                                position: selectedActivity?.name,
                                lat: coordinates?.latitude,
                                long: coordinates?.longitude,
                                tags: tags))
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
                    autoFocus: false,
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<DropDownItems>(
                            icon: Icon(Icons.arrow_drop_up),
                            iconSize: 0,
                            alignment: AlignmentDirectional.center,
                            hint: selectedActivity == null
                                ? const Icon(Icons.accessibility_new)
                                : selectedActivity?.icon,
                            value: selectedActivity,
                            onChanged: (value) {
                              setState(() {
                                selectedActivity = value;
                                print(selectedActivity?.name);
                              });
                            },
                            items: activities.map((DropDownItems activity) {
                              return DropdownMenuItem<DropDownItems>(
                                value: activity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    activity.icon,
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<DropDownItems>(
                            icon: Icon(Icons.arrow_drop_up),
                            iconSize: 0,
                            alignment: AlignmentDirectional.center,
                            hint: selectedMood == null
                                ? Icon(Icons.sentiment_very_satisfied_outlined)
                                : selectedMood?.icon,
                            value: selectedMood,
                            onChanged: (value) {
                              setState(() {
                                selectedMood = value;
                                print(selectedMood?.name);
                              });
                            },
                            items: moods.map((DropDownItems mood) {
                              return DropdownMenuItem<DropDownItems>(
                                value: mood,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    mood.icon,
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
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
                        showSmallButton: false,
                        showInlineCode: false,
                        showColorButton: false,
                        showBackgroundColorButton: false,
                        showClearFormat: false,
                        showCodeBlock: false,
                        showLink: false,
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
