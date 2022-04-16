import 'google_place_geometry.dart';

class Place {
  final GooglePlaceGeometry? geometry;
  final String? name;
  final String? vicinity;

  Place({this.geometry, this.name, this.vicinity});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      geometry: GooglePlaceGeometry.fromJson(json['geometry']),
      name: json['formatted_address'],
      vicinity: json['vicinity'],
    );
  }
}
