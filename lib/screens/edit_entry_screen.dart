import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/Entry.dart';
import '../services/entry_data_service.dart';

class EditEntryScreen extends StatefulWidget {
  static const routeName = '/editor';
  const EditEntryScreen({Key? key}) : super(key: key);

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

bool isLoading = false;
List<File> _images = [];

class _EditEntryScreenState extends State<EditEntryScreen> {
  @override
  Widget build(BuildContext context) {
    Entry? selectedDiaryEntry =
        Provider.of<EntryBuilderService>(context, listen: false).entry!;
    return Scaffold(
        appBar: AppBar(
          title: TextButton(
            onPressed: () {
              // _selectDate(context);
            },
            child: Text(
              DateFormat('MMM d, ' 'yyyy')
                  .format(selectedDiaryEntry.date as DateTime),
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
              itemBuilder: (BuildContext bc) {
                return [
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.location_on, color: Colors.black),
                        // Text.Text(place == null
                        //     ? 'Current Location'
                        //     : '${place.locality}, ${place.country}'),
                      ],
                    ),
                    value: 'sad',
                    onTap: () async {
                      // Position position = await Provider.of<LocationService>(
                      //         context,
                      //         listen: false)
                      //     .getLocationCoordinates();
                      // Placemark location = await Provider.of<LocationService>(
                      //         context,
                      //         listen: false)
                      //     .getAddressFromCoordinates(position);
                      // place = location;
                      // print(place.country);
                    },
                  ),
                ];
              },
            ),
            _images.isNotEmpty
                ? Badge(
                    badgeColor: Colors.white70,
                    badgeContent: (Text('1')),
                    position: BadgePosition.topEnd(top: 0, end: 0),
                    child: IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: () async {}),
                  )
                : IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () async {},
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
                      setState(() {});
                    },
                  ),
          ],
        ),
        body: Container());
  }
}
