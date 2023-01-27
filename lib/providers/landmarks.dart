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
  int mpid = 0;

  Coord({
    required this.x,
    required this.y,
    required this.group,
    required this.mpid,
  });

  Coord.clone(Coord other) {
    x = other.x;
    y = other.y;
    group = other.group;
    mpid = other.mpid;
  }
}

class Landmarks with ChangeNotifier {
  int _markerSize = 7;
  int _markerInvisPadding = 5;
  Poses? _currentPose;
  Size? _currentImageSize;
  Size? _containerDimension;
  Map<Poses, List<Coord>> _faceLandmarks = {
    Poses.resting: [
      Coord(x: 0, y: 0.3, group: MarkerGroup.eye, mpid: 1),
      Coord(x: 0.3, y: 0, group: MarkerGroup.eye, mpid: 2),
      Coord(x: 0.5, y: 0.5, group: MarkerGroup.eye, mpid: 3),
      Coord(x: 0.2, y: 0.3, group: MarkerGroup.mouth, mpid: 236),
      Coord(x: 0.2, y: 0.4, group: MarkerGroup.mouth, mpid: 45),
      Coord(x: 0.2, y: 0.5, group: MarkerGroup.mouth, mpid: 67),
    ],
    Poses.browLift: [
      Coord(x: 0.4, y: 0.5, group: MarkerGroup.brow, mpid: 120),
      Coord(x: 0.5, y: 0.5, group: MarkerGroup.eye, mpid: 88),
      Coord(x: 0.6, y: 0.5, group: MarkerGroup.mouth, mpid: 77),
    ]
  };

  List<Coord> get getFaceLandmark => (_faceLandmarks.containsKey(_currentPose))
      ? _faceLandmarks[_currentPose]!
      : [];

  Poses? get getCurrentPose => _currentPose;

  Size get getCurrentImageSize =>
      _currentImageSize ?? Size(width: 0, height: 0);

  Size get getContainerDimension =>
      _containerDimension ?? Size(width: 0, height: 0);

  int get getMarkerSize => _markerSize;
  int get getMarkerInvisPadding => _markerInvisPadding;

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
