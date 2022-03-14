import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'Tag.freezed.dart';
part 'Tag.g.dart';

@freezed
class Tag with _$Tag {
  const Tag._();

  @JsonSerializable(explicitToJson: true)
  factory Tag({
    String? entryId,
    String? tag,
    String? userId,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  factory Tag.fromDocument(QueryDocumentSnapshot data) {
    return Tag(
      entryId: data.id,
      userId: data.get('uid'),
      tag: data.get('tag'),
    );
  }

  Map<String, dynamic> toMap() {
    return {'tag': tag, 'uid': userId};
  }
}
