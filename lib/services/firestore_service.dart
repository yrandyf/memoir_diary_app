import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/Entry.dart';

class FirestoreService extends ChangeNotifier {
  Future<List<Entry>> getEntries(String uid) async {
    var entry = await FirebaseFirestore.instance
        .collection('entries')
        .where('uid', isEqualTo: uid)
        .get();
    return entry.docs.map((doc) {
      return Entry.fromDocument(doc);
    }).toList();
  }

  Future<void> createEntry(Entry entry) async {
    var userEntries = FirebaseFirestore.instance.collection("entries");
    userEntries.add(entry.toMap());
    notifyListeners();
  }

  Future<void> deleteEntry(String entryId, List<dynamic> imageList) async {
    print(entryId);
    var userEntries = FirebaseFirestore.instance.collection("entries");
    await userEntries
        .doc(entryId)
        .delete()
        .then((_) => deleteImages(imageList));
    notifyListeners();
  }

  Future deleteImages(List<dynamic> imageList) async {
    for (var imgLink in imageList) {
      await FirebaseStorage.instance.refFromURL(imgLink).delete().whenComplete(
            () => print('Images are Deleted'),
          );
    }
    notifyListeners();
  }
}
