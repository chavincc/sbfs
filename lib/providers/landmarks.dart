import 'package:flutter/cupertino.dart';

import './faces.dart';
import '../models/size.dart';

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
  int _markerSize = 5;
  Poses? _currentPose;
  Size? _currentImageSize;
  Size? _containerDimension;
  Map<Poses, List<Coord>> _faceLandmarks = {
    Poses.resting: [
      Coord(x: 0, y: 0.3),
      Coord(x: 0.3, y: 0),
      Coord(x: 0.2, y: 0.3),
      Coord(x: 0.2, y: 0.4),
      Coord(x: 0.2, y: 0.5),
      Coord(x: 0.5, y: 0.5),
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
}
