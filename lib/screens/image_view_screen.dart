import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../providers/landmarks.dart';
import '../models/size.dart';
import '../compute/camera_sizing.dart';

class ImageViewScreen extends StatefulWidget {
  static String routeName = '/image-view';

  const ImageViewScreen({Key? key}) : super(key: key);

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  late List<Coord> _faceLandmarks;
  late Size _containerDimension;

  @override
  void initState() {
    // load landmark once
    final landmarksProvider = Provider.of<Landmarks>(context, listen: false);
    // deepcopy
    _faceLandmarks = landmarksProvider.getFaceLandmark
        .map((Coord c) => Coord.clone(c))
        .toList();
    // denormalize position
    final imageSize = landmarksProvider.getCurrentImageSize!;
    _containerDimension = landmarksProvider.getContainerDimension!;
    final scaledImageSize = getCameraRenderedSize(
      previewWidth: imageSize.width,
      previewHeight: imageSize.height,
      screenWidth: _containerDimension.width,
      screenHeight: _containerDimension.height,
    );

    for (Coord c in _faceLandmarks) {
      c.x = c.x * scaledImageSize.width;
      c.y = c.y * scaledImageSize.height;
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

        return Positioned(
          left: coord.x,
          top: coord.y,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _faceLandmarks[idx].x += details.delta.dx;
                _faceLandmarks[idx].y += details.delta.dy;
              });
            },
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
            ),
          ),
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
