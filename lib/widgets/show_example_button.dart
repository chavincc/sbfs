import 'package:flutter/material.dart';

import '../providers/faces.dart';

class ShowExampleButton extends StatelessWidget {
  final Poses _pose;
  final Map<Poses, String> _pose2imagePath = {
    Poses.resting: 'images/dummy-guide.jpg',
    Poses.browLift: 'images/face-guide.png',
    Poses.eyesClose: 'images/dummy-guide.jpg',
    Poses.lipPucker: 'images/dummy-guide.jpg',
    Poses.smile: 'images/dummy-guide.jpg',
    Poses.snarl: 'images/dummy-guide.jpg',
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
            return Image(
              image: AssetImage(
                _pose2imagePath[_pose]!,
              ),
            );
          },
        );
      },
    );
  }
}
