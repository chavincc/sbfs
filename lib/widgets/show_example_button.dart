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
    Poses.resting: 'images/dummy-guide.jpg',
    Poses.browLift: 'images/brow-lift-example.png',
    Poses.eyesClose: 'images/dummy-guide.jpg',
    Poses.lipPucker: 'images/dummy-guide.jpg',
    Poses.smile: 'images/dummy-guide.jpg',
    Poses.snarl: 'images/dummy-guide.jpg',
  };

  final Map<Poses, List<Widget>> _pose2description = {
    Poses.resting: [],
    Poses.browLift: [
      buildDescriptionLine(
        '105, 334 on upper border of 2/3 lateral of eyebrow',
      ),
      buildDescriptionLine(
        '68, 473 on midpupil',
      ),
    ],
    Poses.eyesClose: [],
    Poses.lipPucker: [],
    Poses.smile: [],
    Poses.snarl: [],
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
        showModalBottomSheet<void>(
          context: context,
          builder: (builder) {
            return SizedBox(
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
            );
          },
        );
      },
    );
  }
}
