import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memoir_diary_app/models/Entry.dart';
import '../utils/icon_switch.dart';
import '/widgets/main_screen/entry_list_item.dart';
import '/widgets/main_screen/flexible_space_widget.dart';

class MoodCategorizedEntryListView extends StatefulWidget {
  static const routeName = '/categorizedListView';
  const MoodCategorizedEntryListView({Key? key}) : super(key: key);

  @override
  State<MoodCategorizedEntryListView> createState() =>
      _MoodCategorizedEntryListViewState();
}

class _MoodCategorizedEntryListViewState
    extends State<MoodCategorizedEntryListView> {
  CollectionReference entryRef =
      FirebaseFirestore.instance.collection("entries");

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    String mood = ModalRoute.of(context)!.settings.arguments.toString();

    return Scaffold(
      appBar: AppBar(title: setMoodIcon(mood)),
      body: StreamBuilder<QuerySnapshot>(
        stream: entryRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> entries) {
          if (entries.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List userEntryList = entries.data!.docs
              .map((entry) {
                return Entry.fromDocument(entry);
              })
              .where((entry) =>
                  entry.userId == FirebaseAuth.instance.currentUser!.uid &&
                  entry.mood == mood)
              .toList();

          return (userEntryList.isEmpty)
              ? const Center(child: Text('No Entires!'))
              : CustomScrollView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        Entry entry = userEntryList[index];

                        return EntryListItem(
                          entry: entry,
                          entryRef: entryRef,
                        );
                      }, childCount: userEntryList.length),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
