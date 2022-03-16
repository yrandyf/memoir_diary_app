import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memoir_diary_app/models/Tag.dart';

class TagService extends ChangeNotifier {
  
  Future<void> createTag(Tag tag) async {
    var tags = FirebaseFirestore.instance.collection("tags");
    tags.add(tag.toMap()).catchError((error) => print('Update failed: $error'));
    notifyListeners();
  }
}
