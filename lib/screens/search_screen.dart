import 'dart:async';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/AlgoliaAppInit.dart';
import '../models/Entry.dart';
import '../models/Tag.dart';
import '../services/entry_data_service.dart';
import '../utils/icon_switch.dart';
import 'activity_categorized_list.dart';
import 'categorized_tags_listview.dart';
import 'mood_categorized_entry_list_view.dart';
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
  final searchTextController = TextEditingController();

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
            controller: searchTextController,
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
        body: searchTextController.text.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mood',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.sentiment_very_satisfied_outlined,
                                  size: 45,
                                  color: Colors.green[400],
                                ),
                                onPressed: () {
                                  String mood = "Happy";
                                  Navigator.of(context).pushNamed(
                                      MoodCategorizedEntryListView.routeName,
                                      arguments: mood);
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.sentiment_neutral_outlined,
                                  size: 45,
                                  color: Colors.blueGrey[400],
                                ),
                                onPressed: () {
                                  String mood = "Average";
                                  Navigator.of(context).pushNamed(
                                      MoodCategorizedEntryListView.routeName,
                                      arguments: mood);
                                }),
                            IconButton(
                                icon: const Icon(
                                  Icons.sentiment_dissatisfied_sharp,
                                  size: 45,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  String mood = "Sad";
                                  Navigator.of(context).pushNamed(
                                      MoodCategorizedEntryListView.routeName,
                                      arguments: mood);
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.sentiment_very_dissatisfied_outlined,
                                  size: 45,
                                  color: Colors.blueGrey[200],
                                ),
                                onPressed: () {
                                  String mood = "Dissatisfied";
                                  Navigator.of(context).pushNamed(
                                      MoodCategorizedEntryListView.routeName,
                                      arguments: mood);
                                }),
                          ]),
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),
                      const Text(
                        'Activity',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              String activty = "Standing";
                              Navigator.of(context).pushNamed(
                                  ActivityCategorizedEntryListView.routeName,
                                  arguments: activty);
                            },
                            child: const Chip(
                              shape: StadiumBorder(side: BorderSide()),
                              labelPadding: EdgeInsets.only(
                                  left: 9.0, right: 9.0, top: 3.0, bottom: 3.0),
                              avatar: Icon(Icons.boy_outlined),
                              padding: EdgeInsets.all(0),
                              backgroundColor: Colors.white,
                              label: Text('Standing'),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              String activty = "Walking";
                              Navigator.of(context).pushNamed(
                                  ActivityCategorizedEntryListView.routeName,
                                  arguments: activty);
                            },
                            child: const Chip(
                              shape: StadiumBorder(side: BorderSide()),
                              labelPadding: EdgeInsets.only(
                                  left: 9.0, right: 9.0, top: 3.0, bottom: 3.0),
                              avatar: Icon(Icons.directions_walk),
                              padding: EdgeInsets.all(0),
                              backgroundColor: Colors.white,
                              label: Text('Walking'),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              String activty = "Sitting";
                              Navigator.of(context).pushNamed(
                                  ActivityCategorizedEntryListView.routeName,
                                  arguments: activty);
                            },
                            child: const Chip(
                              shape: StadiumBorder(side: BorderSide()),
                              labelPadding: EdgeInsets.only(
                                  left: 9.0, right: 9.0, top: 3.0, bottom: 3.0),
                              avatar: Icon(Icons.chair),
                              padding: EdgeInsets.all(0),
                              backgroundColor: Colors.white,
                              label: Text('Sitting'),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              String activty = "Nap";
                              Navigator.of(context).pushNamed(
                                  ActivityCategorizedEntryListView.routeName,
                                  arguments: activty);
                            },
                            child: const Chip(
                              shape: StadiumBorder(side: BorderSide()),
                              labelPadding: EdgeInsets.only(
                                  left: 9.0, right: 9.0, top: 3.0, bottom: 3.0),
                              avatar: Icon(Icons.hotel),
                              padding: EdgeInsets.all(0),
                              backgroundColor: Colors.white,
                              label: Text('Nap'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),
                      const Text(
                        'Tags',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 250,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("tags")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> querytags) {
                            if (querytags.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            var userTagsList = querytags.data!.docs
                                .map((tags) {
                                  return Tag.fromDocument(tags);
                                })
                                .where((querytags) =>
                                    querytags.userId ==
                                    FirebaseAuth.instance.currentUser!.uid)
                                .toList();

                            // List filteredUserTagList = userTagsList
                            //     .where((tagsSet) => tags.contains(tagsSet.tag))
                            //     .toList();

                            return ListView.builder(
                              itemCount: userTagsList.length,
                              itemBuilder: (context, index) {
                                Tag tagItem = userTagsList[index];
                                if (userTagsList.isEmpty) {
                                  const Center(
                                    child: Text(
                                      'Add Tags',
                                    ),
                                  );
                                }
                                return Card(
                                  child: ListTile(
                                    title: Text(tagItem.tag.toString()),
                                    onTap: () {
                                      String tag = tagItem.tag as String;
                                      Navigator.of(context).pushNamed(
                                          TagsCategorizedListView.routeName,
                                          arguments: tag);
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      StreamBuilder<List<AlgoliaObjectSnapshot>>(
                        stream: Stream.fromFuture(_operation(_searchTerm)),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text('No Results'),
                            );
                          } else {
                            List<AlgoliaObjectSnapshot>? entrySearchResults =
                                snapshot.data;
                            var userEntryList = entrySearchResults!
                                .map((results) {
                                  return Entry(
                                    timeStamp:
                                        DateTime.fromMillisecondsSinceEpoch(
                                            results.data["time_stamp"]),
                                    tags: results.data["tags"],
                                    image_list: results.data["photo_list"],
                                    content: results.data["content"],
                                    contentSummery:
                                        results.data["content_summery"],
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
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ));
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
                                            return userEntryList.isNotEmpty
                                                ? InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              ViewEntryScreen
                                                                  .routeName);
                                                      Provider.of<EntryBuilderService>(
                                                              context,
                                                              listen: false)
                                                          .setEntry(entry);
                                                      print(entry.date);
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              DateFormat(
                                                                      'EEE, h:mm a')
                                                                  .format(entry
                                                                          .date
                                                                      as DateTime),
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            entry.position !=
                                                                    null
                                                                ? setActivityIcon(entry
                                                                    .position
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
                                                                ? setMoodIcon(
                                                                    entry.mood
                                                                        as String)
                                                                : Container(),
                                                            const SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                              entry.mood
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          entry.contentSummery
                                                              as String,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          maxLines: 4,
                                                          softWrap: true,
                                                          textAlign:
                                                              TextAlign.justify,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                        const Divider(
                                                          color: Colors.black,
                                                        ),
                                                        const SizedBox(
                                                            height: 10)
                                                      ],
                                                    ),
                                                  )
                                                : Container();
                                          },
                                          childCount: entrySearchResults.length,
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
