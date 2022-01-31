import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class GetInfo extends StatelessWidget {
  const GetInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("entries").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text("0 Entries");
        return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: getItems(snapshot),
        );
      },
    );
  }

  getItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => new ListTile(
            title: new Text(doc["display_name"]),
            subtitle: new Text(
              doc["profession"].toString(),
            ),
          ),
        )
        .toList();
  }
}
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
// }
