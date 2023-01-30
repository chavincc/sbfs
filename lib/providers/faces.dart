import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../screens/camera_screen.dart';
import '../compute/face_brightness.dart';
import '../config/http.dart';
import '../models/poses.dart';
import '../providers/landmarks.dart';
import '../widgets/error_dialog.dart';

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

    // _fetching = true;
    // notifyListeners();
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

    // _fetching = false;
    // notifyListeners();

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

  Future<FaceLandmarkResponse> readFaceLandmark(
    BuildContext context,
    String userInputId,
  ) async {
    _fetching = true;
    notifyListeners();
    FaceLandmarkResponse faceLandmarkResponse =
        const FaceLandmarkResponse(faceLandmarks: {}, uid: '');
    try {
      final url = Uri.parse('$endpointUrl/face_landmark');
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
      request.fields['uid'] = userInputId;

      _patientId = userInputId;

      final response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final parsed = jsonDecode(respStr);
        faceLandmarkResponse = FaceLandmarkResponse.fromJson(parsed);
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

    return faceLandmarkResponse;
  }
}

class FaceLandmarkResponse {
  final Map<Poses, List<Coord>> faceLandmarks;
  final String uid;

  const FaceLandmarkResponse({
    required this.faceLandmarks,
    required this.uid,
  });

  factory FaceLandmarkResponse.fromJson(Map<dynamic, dynamic> json) {
    // map response landmark to dart landmark for each post
    Map<Poses, List<Coord>> convertedLandmarks = {};
    for (var pose in Poses.values) {
      convertedLandmarks[pose] = json['landmarks'][pose2respKey[pose]]
          .map(
            (dynamic c) => Coord(
              x: c['x'],
              y: c['y'],
              group: MarkerGroup.brow,
              mpid: c['mpid'],
            ),
          )
          .toList()
          .cast<Coord>();
    }

    return FaceLandmarkResponse(
      uid: json['uid'],
      faceLandmarks: convertedLandmarks,
    );
  }
}
