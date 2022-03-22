// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Entry _$$_EntryFromJson(Map<String, dynamic> json) => _$_Entry(
      entryId: json['entryId'] as String?,
      content: json['content'] as List<dynamic>?,
      contentSummery: json['contentSummery'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      location: json['location'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      long: (json['long'] as num?)?.toDouble(),
      position: json['position'] as String?,
      mood: json['mood'] as String?,
      image_list: json['image_list'] as List<dynamic>?,
      timeStamp: json['timeStamp'] == null
          ? null
          : DateTime.parse(json['timeStamp'] as String),
      userId: json['userId'] as String?,
      tags: json['tags'] as List<dynamic>?,
    );

Map<String, dynamic> _$$_EntryToJson(_$_Entry instance) => <String, dynamic>{
      'entryId': instance.entryId,
      'content': instance.content,
      'contentSummery': instance.contentSummery,
      'date': instance.date?.toIso8601String(),
      'location': instance.location,
      'lat': instance.lat,
      'long': instance.long,
      'position': instance.position,
      'mood': instance.mood,
      'image_list': instance.image_list,
      'timeStamp': instance.timeStamp?.toIso8601String(),
      'userId': instance.userId,
      'tags': instance.tags,
    };
