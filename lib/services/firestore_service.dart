import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/diary_entry.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future saveDiaryEntry(DiaryEntry diaryEntry) {
    return _db
        .collection('diaryEntries')
        .doc(diaryEntry.entryId.toString())
        .set(diaryEntry.toMap() as Map<String, dynamic>);
  }

  Stream getDiaryEntries() {
    return _db.collection('diaryEntries').snapshots().map((snapshot) => snapshot
        .docs
        .map((entry) => DiaryEntry.fromFirestore(entry.data()))
        .toList());
  }

  Future removeentry(String entryId) {
    return _db.collection('diaryEntries').doc(entryId).delete();
  }
}
