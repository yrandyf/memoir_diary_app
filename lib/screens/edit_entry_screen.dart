import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:memoir_diary_app/models/Mood.dart';
import 'package:provider/provider.dart';
import '../models/Entry.dart';
import '../services/entry_data_service.dart';
import '../services/location_service.dart';
import '../widgets/edit_screen/edit_page_image_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class EditEntryScreen extends StatefulWidget {
  static const routeName = '/editor';
  const EditEntryScreen({Key? key}) : super(key: key);

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

List<DropDownItems> moods = <DropDownItems>[
  const DropDownItems('Happy', Icon(Icons.sentiment_very_satisfied_outlined)),
  const DropDownItems('Sad', Icon(Icons.sentiment_dissatisfied_sharp)),
  const DropDownItems('Average', Icon(Icons.sentiment_neutral_outlined)),
  const DropDownItems(
      'Dissatisfied', Icon(Icons.sentiment_very_dissatisfied_outlined))
];
List<DropDownItems> activities = <DropDownItems>[
  const DropDownItems('Standing', Icon(Icons.boy_outlined)),
  const DropDownItems('Walking', Icon(Icons.directions_walk)),
  const DropDownItems('Sitting', Icon(Icons.chair)),
  const DropDownItems('Nap', Icon(Icons.hotel)),
  const DropDownItems('Auto Detect', Icon(Icons.auto_fix_high))
];

var selectedUser;
bool isLoading = false;
var place;
DropDownItems? selectedMood;
DropDownItems? selectedActivity;
List<dynamic>? _tempImageList = [];
String dropdownValue = 'One';

class _EditEntryScreenState extends State<EditEntryScreen> {
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

  @override
  Widget build(BuildContext context) {
    late final quill.QuillController _controller = quill.QuillController(
      document: quill.Document.fromJson(
          Provider.of<EntryBuilderService>(context, listen: false)
              .entry!
              .content as List),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _tempImageList = Provider.of<EntryBuilderService>(context, listen: false)
        .entry!
        .image_list;
    place = Provider.of<EntryBuilderService>(context, listen: false)
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
            onPressed: () {},
            icon: Icon(Icons.tag),
          ),
          PopupMenuButton(
            onSelected: (value) => setState(() {
              // selectedMood = value.toString();
              // print(selectedMood);
            }),
            icon: Icon(selectedDiaryEntry.location == null
                ? Icons.add_location_outlined
                : Icons.location_on_outlined),
            itemBuilder: (BuildContext bc) {
              return [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                          selectedDiaryEntry.location == null
                              ? Icons.add_location_outlined
                              : Icons.location_on_outlined,
                          color: Colors.black),
                      Text(place == null ? 'Get Current Location' : '$place'),
                    ],
                  ),
                  onTap: () async {
                    Position position = await Provider.of<LocationService>(
                            context,
                            listen: false)
                        .getLocationCoordinates();
                    Placemark location = await Provider.of<LocationService>(
                            context,
                            listen: false)
                        .getAddressFromCoordinates(position);
                    place = '${location.locality}, ${location.country}';
                    Provider.of<EntryBuilderService>(context, listen: false)
                        .setLocation(place);
                  },
                ),
              ];
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
                    setState(() {});
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
                            hint: selectedActivity == null
                                ? Icon(Icons.accessibility_new)
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
