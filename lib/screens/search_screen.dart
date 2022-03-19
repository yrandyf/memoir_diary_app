import 'dart:async';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/AlgoliaApp.dart';
import '../models/Entry.dart';
import '../services/entry_data_service.dart';
import '../utils/icon_switch.dart';
import 'view_entry_screen.dart';

class SearchBar extends StatefulWidget {
  static const routeName = '/search';
  SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  String _searchTerm = '';

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("entries").query(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            style: const TextStyle(height: 1.4),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: 'Search for Entries',
              hintStyle: TextStyle(color: Colors.white70),
              fillColor: Colors.white,
              suffixIcon: Icon(
                Icons.search,
                color: Colors.white54,
              ),
              border: InputBorder.none,
            ),
            onChanged: (val) {
              setState(() {
                _searchTerm = val;
              });
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                StreamBuilder<List<AlgoliaObjectSnapshot>>(
                  stream: Stream.fromFuture(_operation(_searchTerm)),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      List<AlgoliaObjectSnapshot>? entrySearchResults =
                          snapshot.data;
                      var userEntryList = snapshot.data!
                          .map((results) {
                            return Entry(
                              timeStamp: DateTime.fromMillisecondsSinceEpoch(
                                  results.data["time_stamp"]),
                              tags: results.data["tags"],
                              image_list: results.data["photo_list"],
                              content: results.data["content"],
                              contentSummery: results.data["content_summery"],
                              mood: results.data["mood"],
                              userId: results.data["uid"],
                              date: DateTime.fromMillisecondsSinceEpoch(
                                  results.data["entry_date"]),
                              entryId: results.data["path"].substring(8),
                              location: results.data["location"],
                              position: results.data["position"],
                            );
                          })
                          .where((entry) =>
                              entry.userId ==
                              FirebaseAuth.instance.currentUser!.uid)
                          .toList();

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Container();
                        default:
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return CustomScrollView(
                              shrinkWrap: true,
                              slivers: <Widget>[
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      Entry entry = userEntryList[index];
                                      return _searchTerm.isNotEmpty
                                          ? InkWell(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    ViewEntryScreen.routeName);
                                                Provider.of<EntryBuilderService>(
                                                        context,
                                                        listen: false)
                                                    .setEntry(entry);
                                                print(entry.date);
                                              },
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                                'EEE, h:mm a')
                                                            .format(entry.date
                                                                as DateTime),
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      entry.position != null
                                                          ? setActivityIcon(
                                                              entry.position
                                                                  .toString())
                                                          : Container(),
                                                      const SizedBox(
                                                        width: 2,
                                                      ),
                                                      Text(
                                                        entry.position
                                                            as String,
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      const SizedBox(
                                                        width: 2,
                                                      ),
                                                      entry.mood != null
                                                          ? setMoodIcon(entry
                                                              .mood as String)
                                                          : Container(),
                                                      const SizedBox(
                                                        width: 2,
                                                      ),
                                                      Text(
                                                        entry.mood.toString(),
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    entry.contentSummery
                                                        as String,
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 4,
                                                    softWrap: true,
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  const Divider(
                                                    color: Colors.black,
                                                  ),
                                                  const SizedBox(height: 20)
                                                ],
                                              ),
                                            )
                                          : Container();
                                    },
                                    childCount: entrySearchResults?.length ?? 0,
                                  ),
                                ),
                              ],
                            );
                          }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DisplaySearchResult extends StatelessWidget {
  final String artDes;
  final String artistName;
  final String genre;

  DisplaySearchResult(
      {Key? key,
      required this.artistName,
      required this.artDes,
      required this.genre})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(
        artDes ?? "",
      ),
      Text(
        artistName ?? "",
      ),
      Text(
        genre ?? "",
      ),
      Divider(
        color: Colors.black,
      ),
      SizedBox(height: 20)
    ]);
  }
}
