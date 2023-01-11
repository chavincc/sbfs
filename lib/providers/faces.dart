import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../screens/camera_screen.dart';
import '../models/scores.dart';
import '../compute/face_brightness.dart';
import '../config/http.dart';

enum Poses { resting, browLift, eyesClose, snarl, smile, lipPucker }

enum AffectedSide { left, right }

Map<Poses, String> requestKeyMap = {
  Poses.resting: 'img0',
  Poses.browLift: 'img1',
  Poses.eyesClose: 'img2',
  Poses.snarl: 'img3',
  Poses.smile: 'img4',
  Poses.lipPucker: 'img5',
};

class Faces with ChangeNotifier {
  bool _fetching = false;
  bool _haveEyeSurgery = false;
  Poses? _currentPose;
  AffectedSide? _affectedSide;
  final Map<Poses, File?> _posesPhoto = {};
  String? _patientId;

  Map<Poses, File?> get getPosesPhoto => _posesPhoto;

  Poses? get getCurrentPose => _currentPose;

  AffectedSide? get getAffectedSide => _affectedSide;

  bool get haveEyeSurgery => _haveEyeSurgery;

  bool get isFetching => _fetching;

  String? get getPatientId => _patientId;

  void setEyeSurgeryValue(bool value) {
    _haveEyeSurgery = value;
    notifyListeners();
  }

  void setAffectedSide(AffectedSide? side) {
    _affectedSide = side;
    notifyListeners();
  }

  void startTakingPhoto(BuildContext context, Poses pose) {
    _currentPose = pose;
    Navigator.of(context).pushNamed(CameraScreen.routeName);
  }

  Future storePhoto(BuildContext context, XFile photoFile) async {
    // final _photo = File(photoFile.path);

    _fetching = true;
    notifyListeners();
    // final faceContour = await detectFaceContour(_photo);
    // if (faceContour == null) {
    //   await _showErrorDialog(context, 'Error', 'No face detected.');
    //   _fetching = false;
    //   notifyListeners();
    //   return;
    // }
    // final decodedImage = decodeImage(_photo);
    // if (decodedImage == null) {
    //   await _showErrorDialog(context, 'Error', 'Fail to decode image.');
    //   _fetching = false;
    //   notifyListeners();
    //   return;
    // }
    // final brightnessIsDifference =
    //     compareFaceBrightnessLR(decodedImage, faceContour);

    _fetching = false;
    notifyListeners();

    if (_currentPose != null) {
      Navigator.of(context).pop();
      _posesPhoto[_currentPose!] = File(photoFile.path);
      notifyListeners();
      // if (brightnessIsDifference) {
      //   await _showErrorDialog(
      //     context,
      //     'Warning',
      //     'Lighting on 2 sides of face might differ too much. Consider retaking photo with better lighting',
      //   );
      // }
    }
  }

  void clearPhoto(Poses pose) {
    _posesPhoto[pose] = null;
    notifyListeners();
  }

  Future<ScoreInstance> computeScore(
      BuildContext context, String userInputId) async {
    _fetching = true;
    notifyListeners();
    ScoreInstance scoreInstance = {};
    try {
      final url = Uri.parse('$endpointUrl/grade_faces');
      final request = http.MultipartRequest('POST', url);

      for (Poses pose in Poses.values) {
        final imageBytes = await _posesPhoto[pose]!.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            requestKeyMap[pose] ?? '',
            imageBytes,
            filename: '${requestKeyMap[pose]}.jpg',
          ),
        );
      }
      request.fields['affectedSide'] =
          _affectedSide == AffectedSide.left ? 'L' : 'R';
      request.fields['hasEyeSurgery'] = _haveEyeSurgery ? '1' : '0';
      request.fields['userInputId'] = userInputId;

      _patientId = userInputId;

      final response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final parsed = jsonDecode(respStr);
        final faceScoreResponse = FaceScoreResponse.fromJson(parsed);
        scoreInstance = faceScoreResponse.scoreInstance;
      } else {
        await _showErrorDialog(
          context,
          'There is something wrong from our side',
          'Server error with status code ${response.statusCode}',
        );
      }
    } catch (error) {
      await _showErrorDialog(
        context,
        'There is something wrong from our side',
        'Error occurred on client side',
      );
    }

    _fetching = false;
    notifyListeners();

    return scoreInstance;
  }
}

Future _showErrorDialog(
    BuildContext context, String title, String detail) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(detail),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('close'),
          ),
        ],
      );
    },
  );
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
