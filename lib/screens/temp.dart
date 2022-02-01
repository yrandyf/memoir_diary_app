import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import '../models/Entry.dart';

class GetInfo extends StatelessWidget {
  const GetInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("entries").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Center(child: Text("You Have No Entries"));
        }

        var userEntryList = snapshot.data!.docs.map((entry) {
          return Entry.fromDocument(entry);
        }).where((entry) {
          return entry.userId == FirebaseAuth.instance.currentUser!.uid;
        }).toList();

        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: userEntryList.length,
          itemBuilder: (context, index) {
            Entry entry = userEntryList[index];
            return EntryListItem(entry: entry);
          },
        );
      },
    );
  }
}

class EntryListItem extends StatelessWidget {
  const EntryListItem({
    Key? key,
    required this.entry,
  }) : super(key: key);

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('MMMM d, yyyy')
                              .format(entry.date as DateTime),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.location_on_outlined,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text('Panadura'),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.run_circle_outlined,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text('Sitting'),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.mood,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text('Happy'),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat('EEE, h:mm a')
                          .format(entry.timeStamp!.toDate()),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${entry.contentSummery}',
                      overflow: TextOverflow.fade,
                      maxLines: 4,
                      softWrap: true,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// child: ListTile(
//         title: Text('${entry.mood}'),
//         subtitle: Text('${entry.contentSummery}'),
//         trailing: Text('${entry.date!.weekday}'),
//       ),


//   getItems(AsyncSnapshot<QuerySnapshot> snapshot) {
//     return snapshot.data!.docs
//         .map(
//           (doc) => new ListTile(
//             title: new Text(doc["position"]),
//             subtitle: new Text(
//               doc["mood"].toString(),
//             ),
//           ),
//         )
//         .toList();
//   }
// }
  // return StreamBuilder<QuerySnapshot>(
  //   stream: FirebaseFirestore.instance.collection('entries').snapshots(),
  //   builder: (context, snapshot) {
  //     if (snapshot.hasError) {
  //       return Text('Something Went Wrong');
  //     }
  //     if (snapshot == ConnectionState.waiting) {
  //       return Text('Loading');
  //     }

  //     if (snapshot.connectionState == ConnectionState.done) {
  //       print(snapshot.data);
  //     }
  //     return ListView(
  //       children: snapshot.data!.docs.map(
  //         (DocumentSnapshot document) {
  //           return ListTile(
  //             title: Text(
  //               document.get('display_name'),
  //             ),
  //             subtitle: Text(
  //               document.get('profession'),
  //             ),
  //           );
  //         },
  //       ).toList(),
  //     );
  //   },
  // );
  // }


  // return ListView.builder(
  //         shrinkWrap: true,
  //         scrollDirection: Axis.vertical,
  //         itemCount: userEntryList.length,
  //         itemBuilder: (context, index) {
  //           Entry entry = userEntryList[index];
  //           return EntryListItem(entry: entry);
  //         },
  //       );