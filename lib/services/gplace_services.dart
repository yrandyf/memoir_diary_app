import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/google_place.dart';
import 'package:google_place/google_place.dart' as gp;
import '../models/Place.dart';

class GooglePlaceService extends ChangeNotifier {
  
  final apiKey = 'AIzaSyDhE1MoOH2RUP2JGVlk0pZBDyGUH95TImY';
  List<GooglePlace> searchResults = [];

  Future<List<GooglePlace>> getAutocomplete(String search) async {
    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$apiKey');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    List jsonResults = json['predictions'] as List;

    return jsonResults.map((place) => GooglePlace.fromJson(place)).toList();
  }

  placeSearch(String search) async {
    searchResults = await getAutocomplete(search);
    notifyListeners();
  }

  clearList() {
    searchResults.clear();
    notifyListeners();
  }

  Future<Place> getPlace(String placeId) async {
    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    notifyListeners();
    return Place.fromJson(jsonResult);
  }
}
