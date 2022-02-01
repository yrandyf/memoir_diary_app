import 'package:cloud_firestore/cloud_firestore.dart';

class Entry {
  final String? entryId;
  final List<dynamic>? content;
  final String? contentSummery;
  final DateTime? date;
  final String? location;
  final String? position;
  final String? mood;
  final String? photos;
  final Timestamp? timeStamp;
  final String? userId;

  Entry({
    this.contentSummery,
    this.userId,
    this.photos,
    this.entryId,
    this.content,
    this.date,
    this.location,
    this.position,
    this.mood,
    this.timeStamp,
  });

  factory Entry.fromDocument(QueryDocumentSnapshot data) {
    return Entry(
      entryId: data.id,
      userId: data.get('uid'),
      photos: data.get('photo_list'),
      content: data.get('content'),
      date: data.get('entry_date').toDate(),
      location: data.get('location'),
      position: data.get('position'),
      mood: data.get('mood'),
      contentSummery: data.get('content_summery'),
      timeStamp: data.get('time_stamp'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': userId,
      'photo_list': photos,
      'content': content,
      'entry_date': date,
      'location': location,
      'position': position,
      'mood': mood,
      'time_stamp': timeStamp,
      'content_summery': contentSummery
    };
  }
}
