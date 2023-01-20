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
  late Size _scaledImageSize;

  late int _markerSize;
  late int _markerInvisPadding;

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
    _scaledImageSize = getCameraRenderedSize(
      previewWidth: imageSize.width,
      previewHeight: imageSize.height,
      screenWidth: _containerDimension.width,
      screenHeight: _containerDimension.height,
    );

    // get initial marker size
    _markerSize = landmarksProvider.getMarkerSize;
    _markerInvisPadding = landmarksProvider.getMarkerInvisPadding;

    // denormalize position and adjust per marker shape
    for (Coord c in _faceLandmarks) {
      denormalizeCoord(
        c,
        _scaledImageSize,
        _markerSize.toDouble(),
        _markerInvisPadding.toDouble(),
      );
    }

    super.initState();
  }

  void _handleSaveMarkers(
    BuildContext context,
    List<Coord> rawCoord,
    Size scaledImageSize,
    double markerSize,
    double markerPadding,
  ) {
    for (Coord c in rawCoord) {
      normalizeCoord(c, scaledImageSize, markerSize, markerPadding);
    }
    final landmarkProvider = Provider.of<Landmarks>(context, listen: false);
    landmarkProvider.saveFaceLandmark(rawCoord);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('marker location saved'),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ImageViewScreenArguments;

    List<FaceMarker> markers = [];
    if (args.showMarker) {
      markers = _faceLandmarks.asMap().entries.map(
        (entry) {
          int idx = entry.key;
          Coord coord = entry.value;

          return FaceMarker(
            left: coord.x,
            top: coord.y,
            markerSize: _markerSize.toDouble(),
            markerInvisPadding: _markerInvisPadding.toDouble(),
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
    }

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
          actions: [
            args.showMarker
                ? ElevatedButton(
                    child: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      _handleSaveMarkers(
                        context,
                        _faceLandmarks,
                        _scaledImageSize,
                        _markerSize.toDouble(),
                        _markerInvisPadding.toDouble(),
                      );
                    },
                  )
                : Container(),
          ],
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
  final bool showMarker;

  ImageViewScreenArguments({
    required this.poseString,
    required this.photoFile,
    this.showMarker = false,
  });
}
