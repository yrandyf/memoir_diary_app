// import 'dart:async';
// import 'dart:math';

// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';

// class PlaceAutoComplete extends StatefulWidget {
//   const PlaceAutoComplete({Key? key}) : super(key: key);

//   @override
//   State<PlaceAutoComplete> createState() => _PlaceAutoCompleteState();
// }

// class _PlaceAutoCompleteState extends State<PlaceAutoComplete> {
//   final homeScaffoldKey = GlobalKey<ScaffoldState>();
//   final searchScaffoldKey = GlobalKey<ScaffoldState>();
// Mode _mode = Mode.overlay;
// Widget _buildDropdownMenu() => DropdownButton(
//         value: _mode,
//         items: <DropdownMenuItem<Mode>>[
//           DropdownMenuItem<Mode>(
//             child: Text("Overlay"),
//             value: Mode.overlay,
//           ),
//           DropdownMenuItem<Mode>(
//             child: Text("Fullscreen"),
//             value: Mode.fullscreen,
//           ),
//         ],
//         onChanged: (m) {
//           setState(() {
//             _mode = m;
//           });
//         },
//       );

//       Future<void> _handlePressButton() async {
//     // show input autocomplete with selected mode
//     // then get the Prediction selected
//     Prediction p = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: kGoogleApiKey,
//       onError: onError,
//       mode: _mode,
//       language: "fr",
//       decoration: InputDecoration(
//         hintText: 'Search',
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       components: [Component(Component.country, "fr")],
//     );

//     displayPrediction(p, homeScaffoldKey.currentState);
//   }
// }

// Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
//   if (p != null) {
//     // get detail (lat/lng)
//     GoogleMapsPlaces _places = GoogleMapsPlaces(
//       apiKey: kGoogleApiKey,
//       apiHeaders: await GoogleApiHeaders().getHeaders(),
//     );
//     PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
//     final lat = detail.result.geometry.location.lat;
//     final lng = detail.result.geometry.location.lng;

//     scaffold.showSnackBar(
//       SnackBar(content: Text("${p.description} - $lat/$lng")),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: homeScaffoldKey,
//       appBar: AppBar(
//         title: Text("My App"),
//       ),
//       body: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           _buildDropdownMenu(),
//           ElevatedButton(
//             onPressed: _handlePressButton,
//             child: Text("Search places"),
//           ),
//           ElevatedButton(
//             child: Text("Custom"),
//             onPressed: () {
//               Navigator.of(context).pushNamed("/search");
//             },
//           ),
//         ],
//       )),
//     );
//   }
// }
