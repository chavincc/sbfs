import 'package:flutter/material.dart';

import '../models/scores.dart';

class ScaleDisplay extends StatelessWidget {
  final String _title;
  final TemplateMap _templateMap;
  final int _actualScore;
  final void Function(String, int)? _onPressCallback;

  const ScaleDisplay({
    required String title,
    required TemplateMap templateMap,
    required int actualScore,
    void Function(String, int)? onPressCallback,
    Key? key,
  })  : _title = title,
        _templateMap = templateMap,
        _actualScore = actualScore,
        _onPressCallback = onPressCallback,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _templateMap.entries
                .map(
                  (e) => InkWell(
                    onTap: _onPressCallback != null
                        ? () {
                            _onPressCallback!(_title, e.key);
                          }
                        : null,
                    child: IgnorePointer(
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 30,
                              child: (Checkbox(
                                value: e.key == _actualScore,
                                onChanged: (_) {},
                              )),
                            ),
                            Text(
                              e.key.toString(),
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
