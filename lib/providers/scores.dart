import 'package:flutter/material.dart';

import '../models/scores.dart';

class Scores with ChangeNotifier {
  ScoreInstance _sunnyBrookScore = {};

  ScoreInstance get getSunnyBrookScore => _sunnyBrookScore;

  int getGroupSumScore(String title) {
    int sumScore = 0;
    if (titleGroup.containsKey(title)) {
      final scoreKeys = titleGroup[title];
      for (String key in scoreKeys!) {
        if (_sunnyBrookScore.containsKey(key)) {
          sumScore += _sunnyBrookScore[key]!;
        }
      }
    }
    return sumScore;
  }

  void setSunnyBrookScore(ScoreInstance scoreInstance) {
    _sunnyBrookScore = scoreInstance;
    notifyListeners();
  }

  void setSunnyBrookScoreByKey(String key, int value) {
    _sunnyBrookScore[key] = value;
    notifyListeners();
  }
}
