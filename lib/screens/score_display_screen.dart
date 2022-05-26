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

  static bool canEditScore = true;

  @override
  Widget build(BuildContext context) {
    final _scoreProvider = Provider.of<Scores>(context);
    final _scoreInstance = _scoreProvider.getSunnyBrookScore;

    final _restingTotalScore = _scoreProvider.getGroupSumScore('Resting');
    final _voluntaryMovementTotalScore =
        _scoreProvider.getGroupSumScore('Voluntary Movement');
    final _synkinesisTotalScore = _scoreProvider.getGroupSumScore('Synkinesis');

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
                      onPressCallback: canEditScore
                          ? (title, score) {
                              _scoreProvider.setSunnyBrookScoreByKey(
                                  title, score);
                            }
                          : null,
                    ),
                  )
                  .toList(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 5,
                      ),
                      width: double.infinity,
                      child: const Text(
                        'Resting symmetry score = total × 5',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "= $_restingTotalScore × 5",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "= ${_restingTotalScore * 5}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
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
                      onPressCallback: canEditScore
                          ? (title, score) {
                              _scoreProvider.setSunnyBrookScoreByKey(
                                  title, score);
                            }
                          : null,
                    ),
                  )
                  .toList(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 5,
                      ),
                      width: double.infinity,
                      child: const Text(
                        'Voluntary movement score = total × 4',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "= $_voluntaryMovementTotalScore × 4",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "= ${_voluntaryMovementTotalScore * 4}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
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
                      onPressCallback: canEditScore
                          ? (title, score) {
                              _scoreProvider.setSunnyBrookScoreByKey(
                                  title, score);
                            }
                          : null,
                    ),
                  )
                  .toList(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 5,
                      ),
                      width: double.infinity,
                      child: const Text(
                        'Synkinesis score = total',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "= $_synkinesisTotalScore",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 30),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(173, 216, 230, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    const ScoreTitle(text: 'Composite Score'),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 5,
                      ),
                      width: double.infinity,
                      child: const Text(
                        '= Voluntary movement score - Resting symmetry score - Synkinesis score',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 5,
                      ),
                      width: double.infinity,
                      child: Text(
                        '= ${_voluntaryMovementTotalScore * 4} - ${_restingTotalScore * 5} - $_synkinesisTotalScore',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        '= ${_voluntaryMovementTotalScore * 4 - _restingTotalScore * 5 - _synkinesisTotalScore}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
