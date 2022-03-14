import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/Entry.dart';

class FirestoreService extends ChangeNotifier {
  // Stream<QuerySnapshot> streamEntries(String uid) {
  //   var userEntries = FirebaseFirestore.instance
  //       .collection("entries")
  //       .orderBy("entry_date", descending: true)
  //       .where('uid', isEqualTo: uid)
  //       .snapshots();

  //   var dock = userEntries.data.docs;

  //   return userEntries.data.docs.map((doc) {
  //     return Entry.fromDocument(doc);
  //   }).toList();
  // }

  Future<List<Entry>> getEntries(String uid) async {
    var userEntries = await FirebaseFirestore.instance
        .collection('entries')
        .orderBy("entry_date", descending: true)
        .where('uid', isEqualTo: uid)
        .get();
    return userEntries.docs.map((doc) {
      return Entry.fromDocument(doc);
    }).toList();
  }

  // StreamBuilder<List<Entry>> streamEntries(String uid)  {
  //   var userEntries =  FirebaseFirestore.instance
  //       .collection('entries')
  //       .orderBy("entry_date", descending: true)
  //       .where('uid', isEqualTo: uid)
  //       .get();
  //   return userEntries.docs.map((doc) {
  //     return Entry.fromDocument(doc);
  //   }).toList();
  // }

  Future<void> createEntry(Entry entry) async {
    var userEntries = FirebaseFirestore.instance.collection("entries");
    userEntries
        .add(entry.toMap())
        .catchError((error) => print('Update failed: $error'));
    notifyListeners();
  }

  Future<void> deleteEntry(String entryId, List<dynamic> imageList) async {
    print(entryId);
    var userEntries = FirebaseFirestore.instance.collection("entries");
    await userEntries
        .doc(entryId)
        .delete()
        .catchError((error) => print('Update failed: $error'))
        .then((_) => deleteImages(imageList));
    notifyListeners();
  }

  Future deleteImages(List<dynamic> imageList) async {
    for (var imgLink in imageList) {
      await FirebaseStorage.instance
          .refFromURL(imgLink)
          .delete()
          .catchError((error) => print('Update failed: $error'))
          .whenComplete(
            () => print('Images are Deleted'),
          );
    }
    notifyListeners();
  }

  Future<void> updateEntry(entryId, Entry entry) async {
    var collection = FirebaseFirestore.instance.collection('entries');
    collection
        .doc(entryId) // <-- Doc ID where data should be updated.
        .update(entry.toMap()) // <-- Updated data
        .then((_) => print('Entry Updated'))
        .catchError((error) => print('Update failed: $error'));
  }

  notifyListeners();
}
