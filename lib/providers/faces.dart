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

class Faces with ChangeNotifier {
  bool _fetching = false;
  bool _haveEyeSurgery = false;
  Poses? _currentPose;
  AffectedSide? _affectedSide;
  final Map<Poses, File?> _posesPhoto = {};

  Map<Poses, File?> get getPosesPhoto => _posesPhoto;

  Poses? get getCurrentPose => _currentPose;

  AffectedSide? get getAffectedSide => _affectedSide;

  bool get haveEyeSurgery => _haveEyeSurgery;

  bool get isFetching => _fetching;

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
    final _photo = File(photoFile.path);

    _fetching = true;
    notifyListeners();
    final faceContour = await detectFaceContour(_photo);
    if (faceContour == null) {
      await _showErrorDialog(context, 'Error', 'No face detected.');
      _fetching = false;
      notifyListeners();
      return;
    }
    final decodedImage = decodeImage(_photo);
    if (decodedImage == null) {
      await _showErrorDialog(context, 'Error', 'Fail to decode image.');
      _fetching = false;
      notifyListeners();
      return;
    }
    final brightnessIsDifference =
        compareFaceBrightnessLR(decodedImage, faceContour);

    _fetching = false;
    notifyListeners();

    if (_currentPose != null) {
      Navigator.of(context).pop();
      _posesPhoto[_currentPose!] = File(photoFile.path);
      notifyListeners();
      if (brightnessIsDifference) {
        await _showErrorDialog(
          context,
          'Warning',
          'Lighting on 2 sides of face might differ too much. Consider retaking photo with better lighting',
        );
      }
    }
  }

  void clearPhoto(Poses pose) {
    _posesPhoto[pose] = null;
    notifyListeners();
  }

  Future<ScoreInstance> computeScore(BuildContext context) async {
    _fetching = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.get(Uri.parse('$endpointUrl/'));
    if (response.statusCode == 200) {
      final scoreInstance =
          FaceScoreResponse.fromJson(jsonDecode(response.body));
    } else {
      await _showErrorDialog(
        context,
        'Network error',
        'There is something wrong from our side',
      );
    }

    _fetching = false;
    notifyListeners();

    return {
      'Eye': 0,
      'Nasolabial': 1,
      'Mouth': 1,
      'Brow Lift': 5,
      'Gentle Eye Closure': 5,
      'Open Mouth Smile': 2,
      'Snarl': 2,
      'Lip Pucker': 1,
      'Brow Lift Synkinesis': 1,
      'Gentle Eye Closure Synkinesis': 0,
      'Open Mouth Smile Synkinesis': 3,
      'Snarl Synkinesis': 3,
      'Lip Pucker Synkinesis': 2,
    };
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
  final int value;

  const FaceScoreResponse({
    required this.value,
  });

  factory FaceScoreResponse.fromJson(Map<String, dynamic> json) {
    return FaceScoreResponse(
      value: json['value'],
    );
  }
}
