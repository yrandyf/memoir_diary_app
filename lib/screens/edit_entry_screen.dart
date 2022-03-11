import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/Entry.dart';
import '../services/entry_data_service.dart';
import '../services/location_service.dart';
import '../widgets/edit_screen/edit_page_image_picker.dart';

class EditEntryScreen extends StatefulWidget {
  static const routeName = '/editor';
  const EditEntryScreen({Key? key}) : super(key: key);

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

bool isLoading = false;
var place;
var selectedMood = '';
var selectedActivity = '';
List<dynamic>? _tempImageList = [];

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
            // _images.isNotEmpty
            //     ? Badge(
            //         badgeColor: Colors.white70,
            //         badgeContent: (Text('1')),
            //         position: BadgePosition.topEnd(top: 0, end: 0),
            //         child: IconButton(
            //             icon: const Icon(Icons.add_a_photo),
            //             onPressed: () async {}),
            //       )
            IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: () async {
                  // if (_images.isEmpty) {
                  // final pickedImages = await Provider.of<ImagesService>(
                  //         context,
                  //         listen: false)
                  //     .picker
                  //     .pickImage(source: ImageSource.gallery);
                  // setState(
                  //   () {
                  //     if (pickedImages == null) {
                  //       return;
                  //     } else {
                  //       _images.add(File(pickedImages!.path));
                  //     }
                  //   },
                  // );
                  // } else {
                  editPageImagePicker(context, _tempImageList);

                  setState(() {});
                }
                // },
                ),
            isLoading
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.library_add_check_outlined),
                    onPressed: () async {
                      setState(() {});
                    },
                  ),
          ],
        ),
        body: Container());
  }
}
