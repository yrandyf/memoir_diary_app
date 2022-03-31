import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'Entry.freezed.dart';
part 'Entry.g.dart';

@freezed
class Entry with _$Entry {
  const Entry._();

  @JsonSerializable(explicitToJson: true)
  factory Entry({
    String? entryId,
    List<dynamic>? content,
    String? contentSummery,
    DateTime? date,
    String? location,
    double? lat,
    double? long,
    String? position,
    String? mood,
    List<dynamic>? image_list,
    DateTime? timeStamp,
    String? userId,
    List<dynamic>? tags,
  }) = _Entry;

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  factory Entry.fromDocument(QueryDocumentSnapshot data) {
    return Entry(
      entryId: data.id,
      userId: data.get('uid'),
      image_list: data.get('photo_list'),
      lat: data.get('lat'),
      long: data.get('long'),
      content: data.get('content'),
      date: data.get('entry_date').toDate(),
      location: data.get('location'),
      position: data.get('position'),
      mood: data.get('mood'),
      contentSummery: data.get('content_summery'),
      timeStamp: data.get('time_stamp').toDate(),
      tags: data.get('tags'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': userId,
      'photo_list': image_list,
      'content': content,
      'entry_date': date,
      'location': location,
      'position': position,
      'lat': lat,
      'long': long,
      'mood': mood,
      'time_stamp': timeStamp,
      'content_summery': contentSummery,
      'tags': tags,
    };
  }
}
