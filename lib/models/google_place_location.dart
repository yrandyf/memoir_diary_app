class GooglePlaceLocation {
  final double? lat;
  final double? long;

  GooglePlaceLocation({this.lat, this.long});

  factory GooglePlaceLocation.fromJson(Map<dynamic, dynamic> parsedJson) {
    return GooglePlaceLocation(lat: parsedJson['lat'], long: parsedJson['lng']);
  }
}
