import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sbfs/screens/score_display_screen.dart';
import 'package:sbfs/widgets/affected_side_input.dart';

import '../providers/faces.dart';
import '../providers/scores.dart';
import '../widgets/image_display.dart';
import '../screens/image_view_screen.dart';

class PosesScreen extends StatelessWidget {
  static String routeName = '/';

  const PosesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final facesProvider = Provider.of<Faces>(context);
    final scoresProvider = Provider.of<Scores>(context, listen: false);

    final screenWidth = MediaQuery.of(context).size.width;

    final _poseImageIsIncomplete = facesProvider.getPosesPhoto.length != 6 ||
        facesProvider.getPosesPhoto.values.contains(null) ||
        facesProvider.getAffectedSide == null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Facial Paralysis Scoring'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(screenWidth * 0.1),
          child: Column(
            children: [
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
                            onTap: () {
                              if (facesProvider.getPosesPhoto[pose] == null) {
                                facesProvider.startTakingPhoto(context, pose);
                              } else {
                                Navigator.of(context).pushNamed(
                                  ImageViewScreen.routeName,
                                  arguments: ImageViewScreenArguments(
                                    photoFile:
                                        facesProvider.getPosesPhoto[pose]!,
                                    pose: _getPoseLabel(pose),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              CheckboxListTile(
                title: const Text(
                  "Patient have eye surgery",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                value: facesProvider.haveEyeSurgery,
                onChanged: (newValue) {
                  if (newValue != null) {
                    facesProvider.setEyeSurgeryValue(newValue);
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              AffectedSideInput(
                value: facesProvider.getAffectedSide,
                onSelectCallback: (side) {
                  facesProvider.setAffectedSide(side);
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade500,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: facesProvider.isFetching || _poseImageIsIncomplete
                      ? null
                      : () async {
                          final _scoreInstance =
                              await facesProvider.computeScore(context);
                          scoresProvider.setSunnyBrookScore(_scoreInstance);
                          Navigator.of(context)
                              .pushNamed(ScoreDisplayScreen.routeName);
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      facesProvider.isFetching
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
                        'Submit',
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
