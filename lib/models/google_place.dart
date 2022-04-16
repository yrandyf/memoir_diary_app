class GooglePlace {
  final String? description;
  final String? placeId;

  GooglePlace({this.description, this.placeId});

  factory GooglePlace.fromJson(Map<String, dynamic> json) {
    return GooglePlace(
        description: json['description'], placeId: json['place_id']);
  }
}
