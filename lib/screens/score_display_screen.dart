import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sbfs/models/scores.dart';

import '../result_pdf/result_pdf.dart';
import '../providers/faces.dart';
import '../providers/scores.dart';
import '../providers/landmarks.dart';
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
    final _facesProvider = Provider.of<Faces>(context, listen: false);
    final _landmarksProvider = Provider.of<Landmarks>(context, listen: false);

    final _restingTotalScore = _scoreProvider.getGroupSumScore('Resting');
    final _voluntaryMovementTotalScore =
        _scoreProvider.getGroupSumScore('Voluntary Movement');
    final _synkinesisTotalScore = _scoreProvider.getGroupSumScore('Synkinesis');

    return Scaffold(
      floatingActionButton: _scoreProvider.getHaveUnsavedChange
          ? FloatingActionButton.extended(
              onPressed: () {},
              label: const Text('unsaved change(s)'),
              backgroundColor: Colors.grey,
            )
          : FloatingActionButton.extended(
              onPressed: () {
                _scoreProvider.reset();
                _facesProvider.reset();
                _facesProvider.reset();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              label: const Text('new case'),
              icon: const Icon(Icons.face_retouching_natural),
            ),
      appBar: AppBar(
        title: const Text('Score'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final updateStorageSuccess = await _scoreProvider
                  .updateScoreStorage(context, _landmarksProvider.getUid ?? '');
              if (updateStorageSuccess) {
                final resultPdf = buildResultPdf(
                  _facesProvider.getPosesPhoto,
                  _facesProvider.getPatientId,
                  _facesProvider.getAffectedSide,
                  _facesProvider.haveEyeSurgery,
                  _scoreInstance,
                  _restingTotalScore,
                  _voluntaryMovementTotalScore,
                  _synkinesisTotalScore,
                );
                final output = await getApplicationDocumentsDirectory();
                final file = File("${output.path}/example.pdf");
                final bytes = await resultPdf.save();
                await file.writeAsBytes(bytes);
                await OpenFilex.open((file.path));
              }
            },
            style: _scoreProvider.getHaveUnsavedChange
                ? ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 70, 67, 255),
                  )
                : null,
            child: Row(
              children: _scoreProvider.isFetching
                  ? const [Text('Saving..')]
                  : const [
                      Icon(Icons.download),
                      Text('Save'),
                    ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              canEditScore
                  ? Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'tap on score to adjust.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'press save to generate pdf report.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
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
