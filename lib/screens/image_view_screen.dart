import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../providers/faces.dart';

class ImageViewScreen extends StatelessWidget {
  static String routeName = '/image-view';

  const ImageViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ImageViewScreenArguments;

    final facesProvider = Provider.of<Faces>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(args.pose),
      ),
      body: InteractiveViewer(
        child: Image.file(args.photoFile),
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
