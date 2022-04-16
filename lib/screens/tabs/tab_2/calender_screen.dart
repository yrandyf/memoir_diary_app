import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../widgets/main_screen/entry_list_item.dart';
import '../../diary_writer_screen.dart';
import '../../../models/Entry.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../services/firestore_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var filteredEntires;
  List<Entry> _listofEntries = [];
  var entryRef = FirebaseFirestore.instance
      .collection("entries")
      .orderBy("entry_date", descending: true);

  @override
  void initState() {
    filteredEntires = Provider.of<FirestoreService>(context, listen: false)
        .getFilteredEntries(Timestamp.fromDate(DateTime.now()).toDate(), uid)
        .then((entry) {
      for (var item in entry) {
        setState(() {
          _listofEntries.add(item);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: SfDateRangePicker(
            onSelectionChanged: (pickedDate) {
              setState(
                () {
                  _listofEntries.clear();
                  selectedDate = pickedDate.value;
                  print(selectedDate);
                  filteredEntires =
                      Provider.of<FirestoreService>(context, listen: false)
                          .getFilteredEntries(
                              Timestamp.fromDate(selectedDate).toDate(), uid)
                          .then((entry) {
                    for (var item in entry) {
                      setState(() {
                        _listofEntries.add(item);
                      });
                    }
                  });
                },
              );
            },
          ),
        ),
        _listofEntries.isNotEmpty
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  Entry entry = _listofEntries[index];

                  return EntryListItem(
                    entry: entry,
                    entryRef: entryRef,
                  );
                }, childCount: _listofEntries.length),
              )
            : SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.39,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Card(
                      elevation: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 30,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 12),
                          const Text('Kindly Select a Date!'),
                          const SizedBox(height: 15),
                          OutlinedButton(
                              child: const Text(
                                'Write a New Entry',
                                style: TextStyle(fontSize: 17),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                              ),
                              onPressed: () => Navigator.of(context).pushNamed(
                                  DiaryWriterScreen.routeName,
                                  arguments: selectedDate))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
