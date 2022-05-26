import 'package:flutter/material.dart';

class ScoreTitle extends StatelessWidget {
  final String _text;

  const ScoreTitle({Key? key, required String text})
      : _text = text,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 25),
      child: Text(
        _text,
        style: const TextStyle(
          fontSize: 29,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
