import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static final CameraPosition restingPosition = CameraPosition(
    target: LatLng(7.8774222, 80.7003428),
    zoom: 7.5,
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  String uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference entries =
      FirebaseFirestore.instance.collection('entries');
  getMarkerData() {
    entries.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        initMarker(doc.data(), doc.id);
      }
    });
  }

  void initMarker(snapDoc, docId) async {
    final MarkerId markerId = MarkerId(docId);
    DateTime dt = (snapDoc["entry_date"] as Timestamp).toDate();
    String formatedDate = DateFormat('dd MMM, EEE, h:mm a').format(dt);

    String entrySummery = snapDoc["content_summery"];
    // print(entrySummery);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(snapDoc['lat'], snapDoc['long']),
      infoWindow: InfoWindow(
          title: formatedDate,
          onTap: () {
            print('lol');
          },
          snippet: entrySummery.length >= 10
              ? '${entrySummery.substring(0, 20)}...'
              : entrySummery),
    );
    setState(() {
      markers[markerId] = marker;
      // print('markers map thing============ = $markers');
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
        initialCameraPosition: restingPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
