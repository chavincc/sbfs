import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/faces.dart';
import '../providers/landmarks.dart';
import '../providers/scores.dart';
import '../widgets/image_display.dart';
import '../widgets/text_copy_display.dart';
import '../screens/image_view_screen.dart';
import '../screens/score_display_screen.dart';
import '../models/size.dart';

class MarkerScreen extends StatefulWidget {
  static String routeName = '/marker';

  const MarkerScreen({Key? key}) : super(key: key);

  @override
  State<MarkerScreen> createState() => _MarkerScreenState();
}

class _MarkerScreenState extends State<MarkerScreen> {
  final bool _showUid = true;

  @override
  Widget build(BuildContext context) {
    final facesProvider = Provider.of<Faces>(context);
    final landmarksProvider = Provider.of<Landmarks>(context);
    final scoresProvider = Provider.of<Scores>(context, listen: false);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenStatusBarPadding = MediaQuery.of(context).padding.top;
    final appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adjust Face Landmark'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(screenWidth * 0.1),
          child: Column(
            children: [
              _showUid
                  ? Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: TextCopyDisplay(
                        label: 'uid',
                        value: landmarksProvider.getUid ?? '',
                      ),
                    )
                  : const SizedBox.shrink(),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'view and adjust face landmarks by tapping on image if needed',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              ...Poses.values
                  .map(
                    (pose) => Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              _getPoseLabel(pose),
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (facesProvider.getPosesPhoto[pose] == null) {
                                facesProvider.startTakingPhoto(context, pose);
                              } else {
                                landmarksProvider.setCurrentPose(pose);

                                // get current image size for later marker transformation
                                final file = facesProvider.getPosesPhoto[pose]!;
                                final decodedImage = await decodeImageFromList(
                                    file.readAsBytesSync());
                                landmarksProvider.setCurrentImageSize(Size(
                                  width: decodedImage.width.toDouble(),
                                  height: decodedImage.height.toDouble(),
                                ));
                                // get screen size for later marker transformation
                                landmarksProvider.setContainerDimension(Size(
                                  width: screenWidth,
                                  height: screenHeight -
                                      appBarHeight -
                                      screenStatusBarPadding,
                                ));

                                Navigator.of(context).pushNamed(
                                  ImageViewScreen.routeName,
                                  arguments: ImageViewScreenArguments(
                                    photoFile:
                                        facesProvider.getPosesPhoto[pose]!,
                                    poseString: _getPoseLabel(pose),
                                    showMarker: true,
                                  ),
                                );
                              }
                            },
                            child: ImageDisplay(
                              imageFile: facesProvider.getPosesPhoto[pose],
                              onClose: () {
                                facesProvider.clearPhoto(pose);
                              },
                              height: screenWidth * 0.8,
                              width: screenWidth * 0.8,
                              enableCloseButton: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: landmarksProvider.isFetching
                      ? null
                      : () async {
                          final affectedSideStr =
                              facesProvider.getAffectedSide == AffectedSide.left
                                  ? 'L'
                                  : 'R';
                          final hasEyeSurgeryStr =
                              facesProvider.haveEyeSurgery ? '1' : '0';
                          final faceScoreResponse = await landmarksProvider
                              .gradeFaceFromAdjustedLandmark(
                            context,
                            affectedSideStr,
                            hasEyeSurgeryStr,
                          );
                          scoresProvider.setSunnyBrookScore(
                              faceScoreResponse.scoreInstance);

                          Navigator.of(context)
                              .pushNamed(ScoreDisplayScreen.routeName);
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      landmarksProvider.isFetching
                          ? Container(
                              height: 20,
                              width: 20,
                              margin: const EdgeInsets.only(right: 20),
                              child: CircularProgressIndicator(
                                color: Colors.grey.shade600,
                              ),
                            )
                          : const SizedBox.shrink(),
                      const Text(
                        'Compute Score',
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _getPoseLabel(Poses pose) {
  if (pose == Poses.resting) {
    return 'Resting';
  } else if (pose == Poses.browLift) {
    return 'Brow Lift';
  } else if (pose == Poses.eyesClose) {
    return 'Eyes Close';
  } else if (pose == Poses.smile) {
    return 'Smile';
  } else if (pose == Poses.snarl) {
    return 'Snarl';
  } else if (pose == Poses.lipPucker) {
    return 'Lip Pucker';
  }
  return '';
}
