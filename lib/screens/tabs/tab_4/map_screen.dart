import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/mapscreen';
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(7.8731, 80.7718),
    zoom: 50,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  String uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference entries =
      FirebaseFirestore.instance.collection('entries');
  getMarkerData() {
    entries.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        print(doc.data());
        initMarker(doc.data(), doc.id);
      }
    });
  }

  void initMarker(snapDoc, docId) async {
    final MarkerId markerId = MarkerId(docId);
    DateTime dt = (snapDoc["entry_date"] as Timestamp).toDate();
    String formatedDate = DateFormat('dd MMM, EEE, h:mm a').format(dt);

    String entrySummery = snapDoc["content_summery"];
    print(entrySummery);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(snapDoc['lat'], snapDoc['long']),
      infoWindow: InfoWindow(
          title: formatedDate,
          snippet: entrySummery.length >= 10
              ? '${entrySummery.substring(0, 20)}...'
              : entrySummery),
    );
    setState(() {
      markers[markerId] = marker;
      print('markers map thing============ = $markers');
    });
  }

  @override
  void initState() {
    getMarkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(('Map'))),
      body: GoogleMap(
        mapToolbarEnabled: false,
        markers: Set<Marker>.of(markers.values),
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),

      // ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
