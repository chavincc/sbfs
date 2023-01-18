import 'package:flutter/material.dart';

import './faces.dart';
import '../models/size.dart';

enum MarkerGroup { brow, eye, mouth }

Map<MarkerGroup, Color> markerGroupColor = {
  MarkerGroup.brow: Colors.green,
  MarkerGroup.eye: Colors.red,
  MarkerGroup.mouth: Colors.lime,
};

class Coord {
  double x = 0;
  double y = 0;
  MarkerGroup group = MarkerGroup.brow;

  Coord({required this.x, required this.y, required this.group});

  Coord.clone(Coord other) {
    x = other.x;
    y = other.y;
    group = other.group;
  }
}

class Landmarks with ChangeNotifier {
  int _markerSize = 7;
  Poses? _currentPose;
  Size? _currentImageSize;
  Size? _containerDimension;
  Map<Poses, List<Coord>> _faceLandmarks = {
    Poses.resting: [
      Coord(x: 0, y: 0.3, group: MarkerGroup.eye),
      Coord(x: 0.3, y: 0, group: MarkerGroup.eye),
      Coord(x: 0.5, y: 0.5, group: MarkerGroup.eye),
      Coord(x: 0.2, y: 0.3, group: MarkerGroup.mouth),
      Coord(x: 0.2, y: 0.4, group: MarkerGroup.mouth),
      Coord(x: 0.2, y: 0.5, group: MarkerGroup.mouth),
    ],
    Poses.browLift: [
      Coord(x: 0.4, y: 0.5, group: MarkerGroup.brow),
      Coord(x: 0.5, y: 0.5, group: MarkerGroup.eye),
      Coord(x: 0.6, y: 0.5, group: MarkerGroup.mouth),
    ]
  };

  List<Coord> get getFaceLandmark => (_faceLandmarks.containsKey(_currentPose))
      ? _faceLandmarks[_currentPose]!
      : [];

  Poses? get getCurrentPose => _currentPose;

  Size? get getCurrentImageSize => _currentImageSize;

  Size? get getContainerDimension => _containerDimension;

  int get getMarkerSize => _markerSize;

  void setCurrentPose(Poses pose) {
    _currentPose = pose;
    notifyListeners();
  }

  void setCurrentImageSize(Size size) {
    _currentImageSize = size;
    notifyListeners();
  }

  void setContainerDimension(Size size) {
    _containerDimension = size;
    notifyListeners();
  }

  void saveFaceLandmark(List<Coord> newCoordList) {
    if (_currentPose != null) {
      _faceLandmarks[_currentPose!] = newCoordList;
    }
  }
}
