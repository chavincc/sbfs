import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

import './screens/camera_screen.dart';
import './screens/poses_screen.dart';
import './screens/image_view_screen.dart';
import './screens/score_display_screen.dart';
import './providers/faces.dart';
import './providers/scores.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Faces()),
        ChangeNotifierProvider(create: (_) => Scores()),
      ],
      child: MaterialApp(
        home: const PosesScreen(),
        routes: {
          CameraScreen.routeName: (_) => CameraScreen(
                cameras: cameras,
              ),
          ImageViewScreen.routeName: (_) => const ImageViewScreen(),
          ScoreDisplayScreen.routeName: (_) => const ScoreDisplayScreen(),
        },
      ),
    );
  }
}
