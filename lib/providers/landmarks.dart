import 'package:flutter/material.dart';

import './faces.dart';
import '../models/size.dart';
import '../models/scores.dart';

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
  int _markerInvisPadding = 2;
  Poses? _currentPose;
  Size? _currentImageSize;
  Size? _containerDimension;
  Map<Poses, List<Coord>> _faceLandmarks = {};

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

  void setFaceLandmark(Map<Poses, List<Coord>> faceLandmarks) {
    _faceLandmarks = faceLandmarks;
    notifyListeners();
  }

  void saveFaceLandmark(List<Coord> newCoordList) {
    if (_currentPose != null) {
      _faceLandmarks[_currentPose!] = newCoordList;
    }
  }

  Future<FaceScoreResponse> gradeFaceFromAdjustedLandmark() async {
    return FaceScoreResponse(scoreInstance: {});
  }
}

class FaceScoreResponse {
  final ScoreInstance scoreInstance;

  const FaceScoreResponse({
    required this.scoreInstance,
  });

  factory FaceScoreResponse.fromJson(List<dynamic> json) {
    return FaceScoreResponse(scoreInstance: {
      'Eye': json[0][0][0],
      'Nasolabial': json[0][0][1],
      'Mouth': json[0][0][2],
      'Brow Lift': json[0][1][0],
      'Gentle Eye Closure': json[0][1][1],
      'Open Mouth Smile': json[0][1][2],
      'Snarl': json[0][1][3],
      'Lip Pucker': json[0][1][4],
      'Brow Lift Synkinesis': json[0][2][0],
      'Gentle Eye Closure Synkinesis': json[0][2][1],
      'Open Mouth Smile Synkinesis': json[0][2][2],
      'Snarl Synkinesis': json[0][2][3],
      'Lip Pucker Synkinesis': json[0][2][4],
    });
  }
}
