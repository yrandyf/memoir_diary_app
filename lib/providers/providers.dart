// import 'package:flutter/material.dart';
// import '../models/diary_entry.dart';
// import 'package:uuid/uuid.dart';
// import '../services/firestore_service.dart';

// class DiaryEntryProvider with ChangeNotifier {
//   final firestoreService = FirestoreService();

//   late String _entryId;
//   late List<dynamic> _content;
//   late DateTime _date;
//   late String _location;
//   late String _position;
//   late String _mood;
//   var uuid = Uuid();

//   // Getters
//   List<dynamic> get content => _content;
//   DateTime get date => _date;
//   String get location => _location;
//   String get position => _position;
//   String get mood => _mood;

//   // Setters
//   setContent(List<dynamic> content) {
//     _content = content;
//   }

//   setDate(DateTime date) {
//     _date = date;
//   }

//   setLocation(String location) {
//     _location = location;
//   }

//   setPosition(String position) {
//     _position = position;
//   }

//   setMood(String Mood) {
//     _mood = mood;
//   }

//   getDiaryEntries(DiaryEntry diaryEntry) {
//     _content = diaryEntry.content;
//     _date = diaryEntry.date;
//     _location = diaryEntry.location;
//     _position = diaryEntry.position;
//     _mood = diaryEntry.mood;
//   }

//   saveEntry() {
//     print(_entryId);
//     if (_entryId == null) {
//       var newDiaryEntry = DiaryEntry(
//           entryId: uuid.v4(),
//           content: content,
//           date: date,
//           location: location,
//           mood: mood,
//           position: position);
//     }
//   }

//   removeProduct(String entryId) {
//     firestoreService.removeentry(entryId);
//   }
// }
