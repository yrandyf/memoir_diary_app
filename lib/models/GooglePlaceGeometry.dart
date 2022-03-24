import 'GooglePlaceLocation.dart';

class GooglePlaceGeometry {
  final GooglePlaceLocation? goolePlaceLocation;

  GooglePlaceGeometry({this.goolePlaceLocation});

  GooglePlaceGeometry.fromJson(Map<dynamic, dynamic> parsedJson)
      : goolePlaceLocation =
            GooglePlaceLocation.fromJson(parsedJson['location']);
}
