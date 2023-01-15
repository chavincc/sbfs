import 'package:flutter/cupertino.dart';

class Coord {
  double x = 0;
  double y = 0;

  Coord({required this.x, required this.y});

  Coord.clone(Coord other) {
    x = other.x;
    y = other.y;
  }
}

class Landmarks with ChangeNotifier {
  List<Coord> _faceLandmarks = [
    Coord(x: 100, y: 100),
    Coord(x: 50, y: 60),
  ];

  List<Coord> get getFaceLandmark =>
      _faceLandmarks.map((Coord c) => Coord.clone(c)).toList();

  void updateFaceLandmarkPosition(
    double newX,
    double newY,
    int landmarkIndex,
  ) {
    if (_faceLandmarks.length > landmarkIndex) {
      _faceLandmarks[landmarkIndex].x = newX;
      _faceLandmarks[landmarkIndex].y = newY;
    }
  }
}
