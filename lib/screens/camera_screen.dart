import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../compute/camera_sizing.dart';
import '../providers/faces.dart';
import '../models/size.dart';

class CameraScreen extends StatefulWidget {
  static String routeName = '/camera';

  final List<CameraDescription> _cameras;

  const CameraScreen({required List<CameraDescription> cameras, Key? key})
      : _cameras = cameras,
        super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget._cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final facesProvider = Provider.of<Faces>(context);

    if (!controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;
    final _faceGuide = Image.asset('images/face-guide.png');

    // get camera preview size (app always use portrait mode -> swap width and height value)
    double _cameraPreviewWidth = controller.value.previewSize?.height ?? 0;
    double _cameraPreviewHeight = controller.value.previewSize?.width ?? 0;

    // get camera preview size adjusted to the screen (its container)
    final _renderedSize = getCameraRenderedSize(
        previewWidth: _cameraPreviewWidth,
        previewHeight: _cameraPreviewHeight,
        screenWidth: _screenWidth,
        screenHeight: _screenHeight);

    const double _faceGuideWidthRatio = 0.8;
    final _originalFaceGuideSize = Size(width: 334, height: 326);
    final _renderedFaceGuideHeight = getFaceGuideRenderedHeight(
        originalFaceGuideSize: _originalFaceGuideSize,
        cameraRenderedWidth: _renderedSize.width,
        faceGuideWidthRatio: _faceGuideWidthRatio);

    const double _cameraMenuHeight = 75;

    return Scaffold(
      body: CameraPreview(
        controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: facesProvider.isFetching
              ? [
                  Container(
                    width: _screenWidth,
                    height: _screenHeight,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      height: 75,
                      width: 75,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ]
              : [
                  SizedBox(
                    width: _screenWidth * _faceGuideWidthRatio,
                    height: _renderedSize.height - _cameraMenuHeight,
                    child: Stack(
                      children: [
                        Positioned(
                          child: _faceGuide,
                          left: 0,
                          right: 0,
                          bottom: (_renderedSize.height * 0.4) -
                              _cameraMenuHeight -
                              (_renderedFaceGuideHeight * 0.5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: _screenWidth,
                    height: _cameraMenuHeight,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.35),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(15),
                          ),
                          onPressed: () async {
                            if (!controller.value.isTakingPicture) {
                              final _photo = await controller.takePicture();
                              await facesProvider.storePhoto(context, _photo);
                            }
                          },
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final ImagePicker _picker = ImagePicker();
                            final _photo = await _picker.pickImage(
                                source: ImageSource.gallery);
                            if (_photo != null) {
                              await facesProvider.storePhoto(context, _photo);
                            }
                          },
                          child: const SizedBox(
                            height: 30,
                            width: 30,
                            child: Icon(
                              Icons.photo,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
        ),
      ),
    );
  }
}
