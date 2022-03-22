import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoir_diary_app/models/Entry.dart';
import 'package:provider/provider.dart';
import '../../../services/firestore_service.dart';
import '/widgets/main_screen/entry_list_item.dart';
import '/widgets/main_screen/flexible_space_widget.dart';
import '../../diary_writer_screen.dart';

class MainHomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  CollectionReference entryRef =
      FirebaseFirestore.instance.collection("entries");

  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(DiaryWriterScreen.routeName);
        },
        child: const Icon(Icons.edit_outlined),
      ),
      body: Consumer<FirestoreService>(
        builder: (_, fireStoreService, __) {
          return StreamBuilder<QuerySnapshot>(
            stream: entryRef.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> entries) {
              if (entries.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var userEntryList = entries.data!.docs
                  .map((entry) {
                    return Entry.fromDocument(entry);
                  })
                  .where((entry) =>
                      entry.userId == FirebaseAuth.instance.currentUser!.uid)
                  .toList();

              return CustomScrollView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: const IconThemeData(
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                    pinned: true,
                    expandedHeight: 60,
                    flexibleSpace: FlexibleSpaceBar(
                      background: FlexibleSpaceBackground(),
                    ),
                  ),
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
          );
        },
      ),
    );
  }
}
