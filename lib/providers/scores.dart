import 'package:flutter/material.dart';

import '../models/scores.dart';

class Scores with ChangeNotifier {
  ScoreInstance _sunnyBrookScore = {};

  ScoreInstance get getSunnyBrookScore => _sunnyBrookScore;

  void setSunnyBrookScore(ScoreInstance scoreInstance) {
    _sunnyBrookScore = scoreInstance;
    notifyListeners();
  }
}
