import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/scores.dart';
import '../widgets/error_dialog.dart';
import '../config/http.dart';

class Scores with ChangeNotifier {
  bool _fetching = false;
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

  bool get isFetching => _fetching;

  void setSunnyBrookScore(ScoreInstance scoreInstance) {
    _sunnyBrookScore = scoreInstance;
    notifyListeners();
  }

  void setSunnyBrookScoreByKey(String key, int value) {
    _sunnyBrookScore[key] = value;
    notifyListeners();
  }

  Future<bool> updateScoreStorage(
    BuildContext context,
    String uid,
  ) async {
    _fetching = true;
    notifyListeners();

    bool updateSuccess = false;
    try {
      final url = Uri.parse('$endpointUrl/score');
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final body = json.encode({
        'uid': uid,
        'score': scoreInstance2json(_sunnyBrookScore),
      });
      final response = await http.put(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        final respStr = response.body;
        final parsed = jsonDecode(respStr);
        updateSuccess = parsed['status'] || false;
      } else {
        await showErrorDialog(
          context,
          'There is something wrong from our side',
          'Server error with status code ${response.statusCode}',
        );
      }
    } catch (error) {
      await showErrorDialog(
        context,
        'There is something wrong from our side',
        'Error occurred on client side',
      );
    }

    _fetching = false;
    notifyListeners();

    return updateSuccess;
  }
}
