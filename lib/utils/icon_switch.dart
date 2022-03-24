import 'package:flutter/material.dart';

setActivityIcon(String name) {
  switch (name) {
    case "Standing":
      print("Standing");
      return Icon(Icons.boy_outlined);
    case "Walking":
      print("Walking");
      return Icon(Icons.directions_walk);
    case "Sitting":
      print("Sitting");
      return Icon(Icons.chair);
    case "Nap":
      print("Nap");
      return Icon(Icons.hotel);
    case "Auto Detect":
      print("AD");
      return Icon(Icons.auto_fix_high);

    default:
      return Icon(Icons.boy_outlined);
  }
}

setMoodIcon(String name) {
  switch (name) {
    case "Happy":
      print("Case Happy");
      return Icon(Icons.sentiment_very_satisfied_outlined);
    case "Sad":
      print("Case Sad");
      return Icon(Icons.sentiment_dissatisfied_sharp);
    case "Average":
      print("Case Average");
      return Icon(Icons.sentiment_neutral_outlined);
    case "Dissatisfied":
      print("Case Dissatisfied");
      return Icon(Icons.sentiment_very_dissatisfied_outlined);
    default:
      return Icon(Icons.sentiment_very_satisfied_outlined);
  }
}

setMoodIconLarge(String name) {
  switch (name) {
    case "Happy":
      print("Case Happy");
      return Icon(Icons.sentiment_very_satisfied_outlined, size: 45);
    case "Sad":
      print("Case Sad");
      return Icon(Icons.sentiment_dissatisfied_sharp, size: 45);
    case "Average":
      print("Case Average");
      return Icon(Icons.sentiment_neutral_outlined, size: 45);
    case "Dissatisfied":
      print("Case Dissatisfied");
      return Icon(Icons.sentiment_very_dissatisfied_outlined, size: 45);
    default:
      return Icon(Icons.sentiment_very_satisfied_outlined, size: 45);
  }
}
