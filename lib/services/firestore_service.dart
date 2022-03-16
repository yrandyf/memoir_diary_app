import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/Entry.dart';
import '../models/Tag.dart';

class FirestoreService extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Future<void> createEntry(Entry entry) async {
    var userEntries = FirebaseFirestore.instance.collection("entries");
    userEntries
        .add(entry.toMap())
        .catchError((error) => print('Entry Insertion failed: $error'));
    notifyListeners();
  }

  Future<void> deleteEntry(String entryId, List<dynamic> imageList) async {
    print(entryId);
    var userEntries = FirebaseFirestore.instance.collection("entries");
    await userEntries
        .doc(entryId)
        .delete()
        .catchError((error) => print('Entry Deletion failed: $error'))
        .then((_) => deleteImages(imageList));
    notifyListeners();
  }

  Future deleteImages(List<dynamic> imageList) async {
    for (var imgLink in imageList) {
      await FirebaseStorage.instance
          .refFromURL(imgLink)
          .delete()
          .catchError((error) => print('Image Deletion failed: $error'))
          .whenComplete(
            () => print('Images are Deleted'),
          );
    }
    notifyListeners();
  }

  Future<void> updateEntry(entryId, Entry entry) async {
    var collection = FirebaseFirestore.instance.collection('entries');
    collection
        .doc(entryId)
        .update(entry.toMap())
        .then((_) => print('Entry Updated'))
        .catchError((error) => print('Update failed: $error'));
    notifyListeners();
  }

  Future<void> createTag(Tag tag) async {
    var tags = FirebaseFirestore.instance.collection("tags");
    tags.add(tag.toMap()).catchError((error) => print('Update failed: $error'));
    notifyListeners();
  }

  Future<List<DocumentSnapshot>> getSuggestion(String suggestion) async =>
      await _firestore
          .collection('tags')
          .where('tag', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });

  Future<List<QueryDocumentSnapshot>> getSearch() async =>
      await _firestore.collection('tags').get().then((snaps) {
        return snaps.docs;
      });
}
