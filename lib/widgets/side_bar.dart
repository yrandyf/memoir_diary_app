import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoir_diary_app/screens/auth/login_screen.dart';
import 'package:memoir_diary_app/services/firebase_user_auth.dart';
import '../models/Tag.dart';
import '../screens/categorized_tags_listview.dart';
import '../screens/map_screen/map_screen.dart';
import '../screens/settings_screens/settings_screen.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Memoire',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.10,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'Finest Digital Diary Experience!',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    color: Colors.blueGrey,
                  ),
                ),
                const Divider(),
                Text(
                  FirebaseAuth.instance.currentUser!.displayName.toString(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  FirebaseAuth.instance.currentUser!.email.toString(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            decoration: const BoxDecoration(),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () =>
                {Navigator.of(context).popUntil((route) => route.isFirst)},
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Map'),
            onTap: () => {
              Navigator.of(context)
                  .pushNamed(MapScreen.routeName)
                  .then((_) => Navigator.of(context).pop())
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {
              Navigator.of(context)
                  .pushNamed(SettingsScreen.routeName)
                  .then((_) => Navigator.of(context).pop())
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              FireBaseAuth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
          Column(
            children: <Widget>[
              // const SizedBox(height: 20.0),
              ExpansionTile(
                title: Row(
                  children: const [
                    Icon(Icons.tag),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Tags",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                children: <Widget>[
                  SizedBox(
                    height: 220,
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

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
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
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Card(
                                child: ListTile(
                                  title: Text(tagItem.tag.toString()),
                                  onTap: () {
                                    String tag = tagItem.tag as String;
                                    Navigator.of(context).pushNamed(
                                        TagsCategorizedListView.routeName,
                                        arguments: tag);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
