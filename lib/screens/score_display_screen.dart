import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sbfs/models/scores.dart';

import '../providers/scores.dart';
import '../widgets/score_title.dart';
import '../widgets/multiple_choice_display.dart';
import '../widgets/scale_display.dart';

class ScoreDisplayScreen extends StatelessWidget {
  static String routeName = '/score-display';

  const ScoreDisplayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scoreProvider = Provider.of<Scores>(context);
    final _scoreInstance = _scoreProvider.getSunnyBrookScore;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Score'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const ScoreTitle(text: 'Resting'),
              ...titleGroup['Resting']!
                  .map(
                    (title) => MultipleChoiceDisplay(
                      title: title,
                      templateMap: scoreTemplate[title]!,
                      actualScore: _scoreInstance[title] ?? 0,
                    ),
                  )
                  .toList(),
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: ScoreTitle(text: 'Voluntary Movement'),
              ),
              ...titleGroup['Voluntary Movement']!
                  .map(
                    (title) => ScaleDisplay(
                      title: title,
                      templateMap: scoreTemplate[title]!,
                      actualScore: _scoreInstance[title] ?? 0,
                    ),
                  )
                  .toList(),
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: ScoreTitle(text: 'Synkinesis'),
              ),
              ...titleGroup['Synkinesis']!
                  .map(
                    (title) => ScaleDisplay(
                      title: title,
                      templateMap: scoreTemplate[title]!,
                      actualScore: _scoreInstance[title] ?? 0,
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
