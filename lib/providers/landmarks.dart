import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './faces.dart';
import '../models/size.dart';
import '../models/scores.dart';
import '../models/poses.dart';
import '../config/http.dart';
import '../widgets/error_dialog.dart';

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
  bool _fetching = false;
  int _markerSize = 7;
  int _markerInvisPadding = 2;
  Poses? _currentPose;
  Size? _currentImageSize;
  Size? _containerDimension;
  Map<Poses, List<Coord>> _faceLandmarks = {};
  String? _uid;

  bool get isFetching => _fetching;

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

  void setUid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  void saveFaceLandmark(List<Coord> newCoordList) {
    if (_currentPose != null) {
      _faceLandmarks[_currentPose!] = newCoordList;
    }
  }

  Future<FaceScoreResponse> gradeFaceFromAdjustedLandmark(
    BuildContext context,
    String affectedSide,
    String hasEyeSurgery,
  ) async {
    _fetching = true;
    notifyListeners();

    FaceScoreResponse faceScoreResponse =
        const FaceScoreResponse(scoreInstance: {});
    try {
      final url = Uri.parse('$endpointUrl/correct_landmark_grade_faces');
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };

      // transform marker to request body
      final Map<String, List<Map<String, dynamic>>> landmarkRequestBody = {};
      for (Poses p in Poses.values) {
        if (_faceLandmarks.containsKey(p)) {
          final String reqKey = pose2respKey[p]!;
          final respLandmark = _faceLandmarks[p]!
              .map(
                (Coord c) => ({
                  "x": c.x,
                  "y": c.y,
                  "group": '',
                  "mpid": c.mpid,
                }),
              )
              .toList();
          landmarkRequestBody[reqKey] = respLandmark;
        }
      }

      final body = json.encode({
        "uid": _uid ?? '',
        "affectedSide": affectedSide,
        "hasEyeSurgery": hasEyeSurgery,
        "landmarks": landmarkRequestBody,
      });
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        final respStr = response.body;
        final parsed = jsonDecode(respStr);
        faceScoreResponse = FaceScoreResponse.fromJson(parsed);
      } else {
        await showErrorDialog(
          context,
          'There is something wrong from our side',
          'Server error with status code ${response.statusCode}',
        );
      }
    } catch (error) {
      await showErrorDialog(
        context,
        'There is something wrong from our side',
        'Error occurred on client side',
      );
    }

    _fetching = false;
    notifyListeners();

    return faceScoreResponse;
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
