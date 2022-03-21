import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memoir_diary_app/models/Entry.dart';
import '../utils/icon_switch.dart';
import '/widgets/main_screen/entry_list_item.dart';

class TagsCategorizedListView extends StatefulWidget {
  static const routeName = '/categorizedTagsView';
  const TagsCategorizedListView({Key? key}) : super(key: key);

  @override
  State<TagsCategorizedListView> createState() =>
      _TagsCategorizedListViewState();
}

class _TagsCategorizedListViewState extends State<TagsCategorizedListView> {
  CollectionReference entryRef =
      FirebaseFirestore.instance.collection("entries");

  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    String tag = ModalRoute.of(context)!.settings.arguments.toString();

    return Scaffold(
      appBar: AppBar(title: Text("Entries with '$tag' tag")),
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
                  entry.tags!.contains(tag))
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
