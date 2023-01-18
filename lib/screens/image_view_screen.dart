import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../providers/landmarks.dart';
import '../models/size.dart';
import '../compute/camera_sizing.dart';
import '../compute/coord_conversion.dart';
import '../widgets/face_marker.dart';

class ImageViewScreen extends StatefulWidget {
  static String routeName = '/image-view';

  const ImageViewScreen({Key? key}) : super(key: key);

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  late List<Coord> _faceLandmarks;
  late Size _containerDimension;
  late int _markerSize;

  @override
  void initState() {
    // load landmark once
    final landmarksProvider = Provider.of<Landmarks>(context, listen: false);
    // deepcopy
    _faceLandmarks = landmarksProvider.getFaceLandmark
        .map((Coord c) => Coord.clone(c))
        .toList();

    // get rendered image size
    final imageSize = landmarksProvider.getCurrentImageSize!;
    _containerDimension = landmarksProvider.getContainerDimension!;
    final scaledImageSize = getCameraRenderedSize(
      previewWidth: imageSize.width,
      previewHeight: imageSize.height,
      screenWidth: _containerDimension.width,
      screenHeight: _containerDimension.height,
    );

    // get initial marker size
    _markerSize = landmarksProvider.getMarkerSize;

    // denormalize position and adjust per marker shape
    for (Coord c in _faceLandmarks) {
      denormalizeCoord(c, scaledImageSize, _markerSize.toDouble());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ImageViewScreenArguments;

    final markers = _faceLandmarks.asMap().entries.map(
      (entry) {
        int idx = entry.key;
        Coord coord = entry.value;

        return FaceMarker(
          left: coord.x,
          top: coord.y,
          markerSize: _markerSize.toDouble(),
          onPanUpdate: (details) {
            setState(() {
              _faceLandmarks[idx].x += details.delta.dx;
              _faceLandmarks[idx].y += details.delta.dy;
            });
          },
          color: markerGroupColor[coord.group]!,
        );
      },
    ).toList();

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(args.poseString),
        ),
        body: InteractiveViewer(
          maxScale: 5,
          child: Stack(
            children: [
              Image.file(args.photoFile),
              ...markers,
            ],
          ),
        ),
      ),
    );
  }
}

class ImageViewScreenArguments {
  final String poseString;
  final File photoFile;

  ImageViewScreenArguments({
    required this.poseString,
    required this.photoFile,
  });
}
