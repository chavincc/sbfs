import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/faces.dart';

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
    const _originalFaceGuideWidth = 326;
    const _cameraMenuHeight = 100;

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
                  Container(
                    width: _screenWidth * 0.8,
                    padding: EdgeInsets.only(
                      bottom: (_screenHeight * 0.5) -
                          _cameraMenuHeight -
                          _originalFaceGuideWidth * 0.5,
                    ),
                    child: _faceGuide,
                  ),
                  Container(
                    width: _screenWidth,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
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
                            final _photo = await controller.takePicture();
                            await facesProvider.storePhoto(context, _photo);
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
