import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class ActivityRecognitionApp extends StatefulWidget {
  static const routeName = '/temp';
  @override
  _ActivityRecognitionAppState createState() => _ActivityRecognitionAppState();
}

class _ActivityRecognitionAppState extends State<ActivityRecognitionApp> {
  StreamSubscription<ActivityEvent>? activityStreamSubscription;
  List<ActivityEvent> _events = [];
  ActivityRecognition activityRecognition = ActivityRecognition();

  @override
  void initState() {
    super.initState();
    _init();
    // _events.add(ActivityEvent.unknown());
  }

  @override
  void dispose() {
    activityStreamSubscription?.cancel();
    super.dispose();
  }

  void _init() async {
    // Android requires explicitly asking permission
    if (Platform.isAndroid) {
      if (await Permission.activityRecognition.request().isGranted) {
        _startTracking();
      }
    }

    // iOS does not
    else {
      _startTracking();
    }
  }

  void _startTracking() {
    activityStreamSubscription = activityRecognition
        .activityStream(runForegroundService: true)
        .listen(onData, onError: onError);
  }

  void onData(ActivityEvent activityEvent) {
    print(activityEvent);
    setState(() {
      _events.add(activityEvent);
    });
  }

  void onError(Object error) {
    print('ERROR - $error');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
            itemCount: _events.length,
            reverse: true,
            itemBuilder: (_, int idx) {
              final activity = _events[idx];
              return ListTile(
                leading: _activityIcon(activity.type),
                title: Text(
                    '${activity.type.toString().split('.').last} (${activity.confidence}%)'),
                trailing: Text(activity.timeStamp
                    .toString()
                    .split(' ')
                    .last
                    .split('.')
                    .first),
              );
            }),
      ),
    );
  }

  Icon _activityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.WALKING:
        return Icon(Icons.directions_walk);
      case ActivityType.IN_VEHICLE:
        return Icon(Icons.car_rental);
      case ActivityType.ON_BICYCLE:
        return Icon(Icons.pedal_bike);
      case ActivityType.ON_FOOT:
        return Icon(Icons.directions_walk);
      case ActivityType.RUNNING:
        return Icon(Icons.run_circle);
      case ActivityType.STILL:
        return Icon(Icons.cancel_outlined);
      case ActivityType.TILTING:
        return Icon(Icons.redo);
      default:
        return Icon(Icons.device_unknown);
    }
  }
}
