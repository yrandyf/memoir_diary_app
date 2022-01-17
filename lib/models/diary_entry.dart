class DiaryEntry {
  final String entryId;
  final List<dynamic> content;
  final DateTime date;
  final String location;
  final String position;
  final String mood;

  DiaryEntry(
      {required this.entryId,
      required this.content,
      required this.date,
      required this.location,
      required this.position,
      required this.mood});

  Map toMap() {
    return {
      'entryId': entryId,
      'content': content,
      'date': date,
      'location': location,
      'position': position,
      'mood': mood
    };
  }

  DiaryEntry.fromFirestore(Map firestore)
      : entryId = firestore['entryId'],
        content = firestore['content'],
        date = firestore['date'],
        location = firestore['location'],
        position = firestore['position'],
        mood = firestore['mood'];
}
