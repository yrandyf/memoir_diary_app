import '../models/Entry.dart';

class EntryBuilderService {
  Entry? _entry;

  Entry? get entry => _entry;

  void initEid(String uid) {
    _entry = Entry(entryId: uid);
  }

  void initUid(String uid) {
    _entry = _entry!.copyWith(userId: uid);
  }

  void setSummery(String contentSummery) {
    _entry = _entry!.copyWith(contentSummery: contentSummery);
  }

  void setDate(DateTime date) {
    _entry = _entry!.copyWith(date: date);
  }

  void setLocation(String location) {
    _entry = _entry!.copyWith(location: location);
  }

  void setPosition(String position) {
    _entry = _entry!.copyWith(position: position);
  }

  void endLocation(String mood) {
    _entry = _entry!.copyWith(mood: mood);
  }

  void setImageList(dynamic image_list) {
    _entry = _entry!.copyWith(image_list: image_list);
  }

  void setTransportMode(DateTime timeStamp) {
    _entry = _entry!.copyWith(timeStamp: timeStamp);
  }

  void setEntry(Entry entry) {
    _entry = entry;
  }
}
