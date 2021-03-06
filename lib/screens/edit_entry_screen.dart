import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:memoir_diary_app/models/drop_down_item.dart';
import 'package:memoir_diary_app/screens/tabs/tab_1_main/home_main_tab.dart';
import 'package:memoir_diary_app/services/firestore_service.dart';
import 'package:provider/provider.dart';
import '../models/Entry.dart';
import '../models/Place.dart';
import '../models/Tag.dart';
import '../services/entry_data_service.dart';
import '../services/gplace_services.dart';
import '../services/location_service.dart';
import '../utils/icon_switch.dart';
import '../widgets/edit_screen/edit_page_image_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../widgets/tab_widget.dart';
import '../widgets/tag_sheet.dart';
import 'view_entry_screen.dart';

class EditEntryScreen extends StatefulWidget {
  static const routeName = '/editor';
  const EditEntryScreen({Key? key}) : super(key: key);

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
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

class _EditEntryScreenState extends State<EditEntryScreen> {
  DropDownItems? selectedActivity;
  DropDownItems? selectedMood;
  List tagSearchSugestions = [];
  List tags = [];
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  List<dynamic>? selectedTags = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final tagTextController = TextEditingController();
  CollectionReference? entryRef =
      FirebaseFirestore.instance.collection('entries');
  final locationTextController = TextEditingController();
  // var selectedUser;
  List<dynamic>? selectedEntry;
  bool isLoading = false;
  Placemark? place;
  List<dynamic>? _tempImageList = [];
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // var tagTextController = TextEditingController();
  double? gPlaceLat;
  double? gPlaceLong;
  Position? coordinates;
  String? selectedLocation;

  late final quill.QuillController _controller = quill.QuillController(
    document: quill.Document.fromJson(selectedEntry as List<dynamic>),
    selection: const TextSelection.collapsed(offset: 0),
  );
  _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: Provider.of<EntryBuilderService>(context, listen: false)
          .entry!
          .date as DateTime,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selectedDate != null &&
        selectedDate !=
            Provider.of<EntryBuilderService>(context, listen: false).entry!.date
                as DateTime) {
      setState(
        () {
          Provider.of<EntryBuilderService>(context, listen: false)
              .setDate(selectedDate);
        },
      );
    }
  }

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
    setState(() {});
  }

  @override
  void initState() {
    getDocs();
    super.initState();
  }
  // @override
  // void deactivate() {
  //   super.deactivate();
  //   Provider.of<EntryBuilderService>(context, listen: false).clear();
  // }

  _showLocationSheet(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 5,
      context: ctx,
      builder: (ctx) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
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
                                focusNode: FocusNode(),
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
                                onChanged: (value) {
                                  setState(() {
                                    Provider.of<GooglePlaceService>(context,
                                            listen: false)
                                        .placeSearch(value);
                                  });
                                },
                              ),
                              Visibility(
                                visible: Provider.of<GooglePlaceService>(
                                        context,
                                        listen: false)
                                    .searchResults
                                    .isNotEmpty,
                                child: Container(
                                  height: 220,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Colors.white60,
                                  ),
                                  child: ListView.builder(
                                    itemCount: Provider.of<GooglePlaceService>(
                                            context,
                                            listen: false)
                                        .searchResults
                                        .length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: const Icon(Icons.location_on),
                                        title: Text(
                                            '${Provider.of<GooglePlaceService>(context, listen: false).searchResults[index].description}'),
                                        onTap: () async {
                                          Place gplaceresults = await Provider
                                                  .of<GooglePlaceService>(
                                                      context,
                                                      listen: false)
                                              .getPlace(Provider.of<
                                                          GooglePlaceService>(
                                                      context,
                                                      listen: false)
                                                  .searchResults[index]
                                                  .placeId as String);
                                          setState(() {
                                            Provider.of<GooglePlaceService>(
                                                    context,
                                                    listen: false)
                                                .clearList();
                                          });
                                          FocusNode().unfocus();
                                          locationTextController.clear();

                                          gPlaceLat = gplaceresults.geometry
                                              ?.goolePlaceLocation?.lat;
                                          Provider.of<EntryBuilderService>(
                                                  context,
                                                  listen: false)
                                              .setLat(gPlaceLat as double);

                                          gPlaceLong = gplaceresults.geometry
                                              ?.goolePlaceLocation?.long;
                                          Provider.of<EntryBuilderService>(
                                                  context,
                                                  listen: false)
                                              .setLong(gPlaceLong as double);

                                          Placemark glocation = await Provider
                                                  .of<LocationService>(context,
                                                      listen: false)
                                              .getAddressFromGoogleCoordinates(
                                                  gPlaceLat, gPlaceLong);
                                          print('$gPlaceLat , $gPlaceLong');
                                          place = glocation;
                                          Provider.of<EntryBuilderService>(
                                                  context,
                                                  listen: false)
                                              .setLocation(
                                                  "${place?.locality}, ${place?.country}");
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                  place != null
                                      ? '${place?.locality}, ${place?.country}'
                                      : selectedLocation as String,
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
                                      await Provider.of<LocationService>(
                                              context,
                                              listen: false)
                                          .getLocationCoordinates();
                                  Placemark location =
                                      await Provider.of<LocationService>(
                                              context,
                                              listen: false)
                                          .getAddressFromCoordinates(position);
                                  setState(() {
                                    coordinates = position;
                                    gPlaceLat = coordinates?.latitude;
                                    Provider.of<EntryBuilderService>(context,
                                            listen: false)
                                        .setLat(gPlaceLat as double);
                                    gPlaceLong = coordinates?.longitude;
                                    Provider.of<EntryBuilderService>(context,
                                            listen: false)
                                        .setLong(gPlaceLong as double);

                                    place = location;
                                    Provider.of<EntryBuilderService>(context,
                                            listen: false)
                                        .setLocation(
                                            "${place?.locality}, ${place?.country}");
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
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    tags =
        Provider.of<EntryBuilderService>(context, listen: false).entry!.tags!;
    String? activity = Provider.of<EntryBuilderService>(context, listen: false)
        .entry!
        .position;
    String? mood =
        Provider.of<EntryBuilderService>(context, listen: false).entry!.mood;
    selectedEntry =
        Provider.of<EntryBuilderService>(context, listen: false).entry?.content;
    _tempImageList = Provider.of<EntryBuilderService>(context, listen: false)
        .entry!
        .image_list;
    selectedLocation = Provider.of<EntryBuilderService>(context, listen: false)
        .entry!
        .location;
    Entry? selectedDiaryEntry =
        Provider.of<EntryBuilderService>(context, listen: false).entry!;
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () {
            _selectDate(context);
          },
          child: Text(
            DateFormat('MMM d, ' 'yyyy')
                .format(selectedDiaryEntry.date as DateTime),
            style: TextStyle(color: Colors.white, fontSize: 15),
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
            icon: Icon(Icons.location_on_outlined),
            onPressed: () {
              print(place);
              _showLocationSheet(context);
            },
          ),
          IconButton(
              icon: _tempImageList!.isNotEmpty
                  ? Icon(Icons.photo_library)
                  : Icon(Icons.add_photo_alternate),
              onPressed: () async {
                editPageImagePicker(context, _tempImageList);
                setState(() {});
              }),
          isLoading
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.library_add_check),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                      // Setting content with formatting.
                      (Provider.of<EntryBuilderService>(context, listen: false)
                          .setContent(_controller.document.toDelta().toJson()));
                      // Setting content without formatitng.
                      (Provider.of<EntryBuilderService>(context, listen: false)
                          .setSummery(_controller.plainTextEditingValue.text));
                      // Time Stamp setup
                      (Provider.of<EntryBuilderService>(context, listen: false)
                          .setTimeStamp(DateTime.now()));
                      Provider.of<FirestoreService>(context, listen: false)
                          .updateEntry(
                              Provider.of<EntryBuilderService>(context,
                                      listen: false)
                                  .entry!
                                  .entryId,
                              (Provider.of<EntryBuilderService>(context,
                                      listen: false)
                                  .entry as Entry))
                          .whenComplete(
                        () {
                          print('Entry Updated');
                          isLoading = false;
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                      );
                    });
                  },
                ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 15, right: 15),
                  child: quill.QuillEditor(
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
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                          hint: mood == null
                              ? Icon(Icons.sentiment_satisfied_alt)
                              : setMoodIcon(mood),
                          value: selectedMood,
                          onChanged: (value) {
                            setState(() {
                              // selectedMood = value;
                              Provider.of<EntryBuilderService>(context,
                                      listen: false)
                                  .setMood(value?.name as String);
                              print(value?.name);
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
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
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
                            hint: activity == null
                                ? Icon(Icons.accessibility_new)
                                : setActivityIcon(activity),
                            value: selectedActivity,
                            onChanged: (value) {
                              setState(() {
                                print('provider activity data = ${activity}');
                                // selectedActivity = value;
                                Provider.of<EntryBuilderService>(context,
                                        listen: false)
                                    .setPosition(value?.name as String);
                                print(value?.name);
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
                    child: quill.QuillToolbar.basic(
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
    );
  }
}
