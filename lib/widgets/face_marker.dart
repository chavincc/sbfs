import 'package:flutter/material.dart';

class FaceMarker extends StatelessWidget {
  final double _left;
  final double _top;
  final double _markerSize;
  final void Function(DragUpdateDetails)? _onPanUpdate;
  final Color _color;

  const FaceMarker(
      {required double left,
      required double top,
      required double markerSize,
      void Function(DragUpdateDetails)? onPanUpdate,
      Color color = Colors.black,
      Key? key})
      : _left = left,
        _top = top,
        _markerSize = markerSize,
        _onPanUpdate = onPanUpdate,
        _color = color,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left,
      top: _top,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        child: Container(
          width: _markerSize.toDouble(),
          height: _markerSize.toDouble(),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _color,
            border: Border.all(
              width: 1,
              color: Colors.black,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}
