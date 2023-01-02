// import 'dart:io';
// import 'package:image/image.dart' as imglib;
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:point_in_polygon/point_in_polygon.dart';
// import 'package:flutter/material.dart';

// final faceDetector = GoogleMlKit.vision.faceDetector(
//   FaceDetectorOptions(
//     enableContours: true,
//   ),
// );

// int abgrToArgb(int argbColor) {
//   int r = (argbColor >> 16) & 0xFF;
//   int b = argbColor & 0xFF;
//   return (argbColor & 0xFF00FF00) | (b << 16) | r;
// }

// Future<FaceContour?> detectFaceContour(File imageFile) async {
//   final _mlKitInputImage = InputImage.fromFile(imageFile);
//   final List<Face> _faces = await faceDetector.processImage(_mlKitInputImage);
//   if (_faces.isNotEmpty) {
//     final _face = _faces[0];
//     final _faceContour = _face.contours[FaceContourType.face];
//     if (_faceContour != null) {
//       return _faceContour;
//     }
//   }
//   return null;
// }

// imglib.Image? decodeImage(File imageFile) {
//   final decodedImage = imglib.decodeImage(imageFile.readAsBytesSync());
//   return decodedImage;
// }

// bool compareFaceBrightnessLR(
//     imglib.Image decodedImage, FaceContour faceContour) {
//   final List<Point> rightSideFaceContour = <Point>[];
//   final List<Point> leftSideFaceContour = <Point>[];

//   final _faceContourPosList = faceContour.points;
//   for (int i = 0; i <= 17; i++) {
//     leftSideFaceContour.add(
//       Point(
//         x: _faceContourPosList[i].x.round().toDouble(),
//         y: _faceContourPosList[i].y.round().toDouble(),
//       ),
//     );
//   }
//   for (int i = 35; i >= 18; i--) {
//     rightSideFaceContour.add(
//       Point(
//         x: _faceContourPosList[i].x.round().toDouble(),
//         y: _faceContourPosList[i].y.round().toDouble(),
//       ),
//     );
//   }

//   List<double> rightSideRGB = [0, 0, 0];
//   int rightCount = 0;
//   List<double> leftSideRGB = [0, 0, 0];
//   int leftCount = 0;

//   for (int i = 0; i < decodedImage.width; i++) {
//     for (int j = 0; j < decodedImage.height; j++) {
//       final pixel32 = decodedImage.getPixel(i, j);
//       final color = Color(pixel32);
//       if (Poly.isPointInPolygon(
//         Point(
//           x: i.toDouble(),
//           y: j.toDouble(),
//         ),
//         rightSideFaceContour,
//       )) {
//         rightCount += 1;
//         rightSideRGB[0] += color.red;
//         rightSideRGB[1] += color.green;
//         rightSideRGB[2] += color.blue;
//       }
//       if (Poly.isPointInPolygon(
//         Point(
//           x: i.toDouble(),
//           y: j.toDouble(),
//         ),
//         leftSideFaceContour,
//       )) {
//         leftCount += 1;
//         leftSideRGB[0] += color.red;
//         leftSideRGB[1] += color.green;
//         leftSideRGB[2] += color.blue;
//       }
//     }
//   }
//   rightSideRGB = rightSideRGB.map((e) => (e / rightCount)).toList();
//   leftSideRGB = leftSideRGB.map((e) => (e / leftCount)).toList();
//   final rightSideMeanIntensity =
//       rightSideRGB[0] + rightSideRGB[1] + rightSideRGB[2];
//   final leftSideMeanIntensity =
//       leftSideRGB[0] + leftSideRGB[1] + leftSideRGB[2];

//   const thresholdRatio = 1.28;
//   double ratio;
//   print(rightSideMeanIntensity);
//   print(leftSideMeanIntensity);
//   if (rightSideMeanIntensity < leftSideMeanIntensity) {
//     ratio = leftSideMeanIntensity / rightSideMeanIntensity;
//   } else {
//     ratio = rightSideMeanIntensity / leftSideMeanIntensity;
//   }

//   if (ratio > thresholdRatio) {
//     return true;
//   }
//   return false;
// }
