import 'package:flutter/material.dart';

import '../providers/faces.dart';

Widget buildDescriptionLine(String desc) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(
      top: 15,
      left: 5,
    ),
    child: Text(
      desc,
      style: const TextStyle(
        fontSize: 18,
      ),
    ),
  );
}

class ShowExampleButton extends StatelessWidget {
  final Poses _pose;
  final Map<Poses, String> _pose2imagePath = {
    Poses.resting: 'images/resting-example.png',
    Poses.browLift: 'images/brow-lift-example.png',
    Poses.eyesClose: 'images/eyes_closure_example.png',
    Poses.lipPucker: 'images/smile-and-lip-pucker-example.png',
    Poses.smile: 'images/smile-and-lip-pucker-example.png',
    Poses.snarl: 'images/snarl-example.png',
  };

  final Map<Poses, List<Widget>> _pose2description = {
    Poses.resting: [
      buildDescriptionLine(
        'eye brows : upper border of 2/3 lateral of eyebrow',
      ),
      buildDescriptionLine(
        'eyes : upper and lower eyelid of each eye, midpupil, and medial canthus',
      ),
      buildDescriptionLine(
        'mouth : cupid bow, cupid peak, oral commissure, and middle joint of lower lip',
      ),
    ],
    Poses.browLift: [
      buildDescriptionLine(
        '105, 334 on upper border of 2/3 lateral of eyebrow',
      ),
      buildDescriptionLine(
        '68, 473 on midpupil',
      ),
    ],
    Poses.eyesClose: [
      buildDescriptionLine(
        'upper and lower eyelid of each eye',
      ),
      buildDescriptionLine(
        '(159 and 145 on patient\'s right,',
      ),
      buildDescriptionLine(
        '386 and 374 on the left)',
      ),
    ],
    Poses.lipPucker: [
      buildDescriptionLine(
        '0 on the cupid bow',
      ),
      buildDescriptionLine(
        '17 on the middle joint of lower lip',
      ),
      buildDescriptionLine(
        '61, 291 on patient\'s right and left oral commissure',
      ),
    ],
    Poses.smile: [
      buildDescriptionLine(
        '0 on the cupid bow',
      ),
      buildDescriptionLine(
        '17 on the middle joint of lower lip',
      ),
      buildDescriptionLine(
        '61, 291 on patient\'s right and left oral commissure',
      ),
    ],
    Poses.snarl: [
      buildDescriptionLine(
        '133, 362 on patient\'s right and left medial canthus',
      ),
      buildDescriptionLine(
        '37, 267 on patient\'s right and left cupid peak',
      ),
    ],
  };

  ShowExampleButton({required Poses pose, Key? key})
      : _pose = pose,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 227, 102),
      ),
      child: const Text(
        'Example',
        style: TextStyle(
          color: Color.fromARGB(255, 70, 70, 70),
        ),
      ),
      onPressed: () {
        showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          context: context,
          builder: (builder) {
            return Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(
                          _pose2imagePath[_pose]!,
                        ),
                      ),
                      ...(_pose2description[_pose]!.toList()),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
