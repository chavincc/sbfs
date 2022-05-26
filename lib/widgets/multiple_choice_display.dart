import 'package:flutter/material.dart';

import '../models/scores.dart';

class MultipleChoiceDisplay extends StatelessWidget {
  final String _title;
  final TemplateMap _templateMap;
  final int _actualScore;

  const MultipleChoiceDisplay({
    required String title,
    required TemplateMap templateMap,
    required int actualScore,
    Key? key,
  })  : _title = title,
        _templateMap = templateMap,
        _actualScore = actualScore,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              _title,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          ..._templateMap.entries
              .map(
                (e) => Container(
                  margin: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 36,
                        child: Checkbox(
                          value: e.key == _actualScore,
                          onChanged: (_) {},
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: e.key.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            TextSpan(
                              text: ' ${e.value}',
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
