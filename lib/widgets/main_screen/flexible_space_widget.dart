import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:utripi/services/auth_service.dart';
import 'dart:convert';
// import '/util/string_extensions.dart';
// import 'package:geolocator/geolocator.dart';
import '/models/weather.dart';
import 'package:http/http.dart' as http;

class FlexibleSpaceBackground extends StatefulWidget {
  @override
  State<FlexibleSpaceBackground> createState() =>
      _FlexibleSpaceBackgroundState();
}

String greetingMessage() {
  var timeNow = DateTime.now().hour;

  if (timeNow <= 12) {
    return 'Good Morning';
  } else if ((timeNow > 12) && (timeNow <= 16)) {
    return 'Good Afternoon';
  } else if ((timeNow > 16) && (timeNow < 20)) {
    return 'Good Evening';
  } else {
    return 'Good Night';
  }
}

class _FlexibleSpaceBackgroundState extends State<FlexibleSpaceBackground> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Hi ',
                        style: const TextStyle(fontSize: 20),
                      ),
                      TextSpan(
                        text: ("Randeep!"),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Text(
                  greetingMessage(),
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 5),
                          child: Image.network(
                              'https://picsum.photos/250?image=9',
                              height: MediaQuery.of(context).size.width * 0.11,
                              fit: BoxFit.cover),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          ('37 °C'),
                          style: TextStyle(fontSize: 26),
                        ),
                        Text(
                          'Rainy',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
