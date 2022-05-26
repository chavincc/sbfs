import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../screens/camera_screen.dart';
import '../models/scores.dart';
import '../compute/face_brightness.dart';

enum Poses { resting, browLift, eyesClose, snarl, smile, lipPucker }

class Faces with ChangeNotifier {
  bool _fetching = false;
  bool _haveEyeSurgery = false;
  Poses? _currentPose;
  final Map<Poses, File?> _posesPhoto = {};

  Map<Poses, File?> get getPosesPhoto => _posesPhoto;

  Poses? get getCurrentPose => _currentPose;

  bool get haveEyeSurgery => _haveEyeSurgery;

  bool get isFetching => _fetching;

  void setEyeSurgeryValue(bool value) {
    _haveEyeSurgery = value;
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

  Future<ScoreInstance> computeScore() async {
    _fetching = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _fetching = false;
    notifyListeners();

    return {
      'Eye': 0,
      'Nasolabial': 1,
      'Brow Lift': 3,
      'Gentle Eye Closure': 5,
      'Snarl Synkinesis': 1,
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
