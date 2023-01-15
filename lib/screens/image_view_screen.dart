import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../providers/landmarks.dart';

class ImageViewScreen extends StatefulWidget {
  static String routeName = '/image-view';

  const ImageViewScreen({Key? key}) : super(key: key);

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  late List<Coord> _faceLandmarks;

  @override
  void initState() {
    // load landmark once
    final landmarksProvider = Provider.of<Landmarks>(context, listen: false);
    _faceLandmarks = landmarksProvider.getFaceLandmark;

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
    );

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
          title: Text(args.pose),
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
  final String pose;
  final File photoFile;

  ImageViewScreenArguments({
    required this.pose,
    required this.photoFile,
  });
}
