import 'package:flutter/material.dart';

class FaceMarker extends StatelessWidget {
  final double _left;
  final double _top;
  final double _markerSize;
  final void Function(DragUpdateDetails)? _onPanUpdate;

  const FaceMarker(
      {required double left,
      required double top,
      required double markerSize,
      void Function(DragUpdateDetails)? onPanUpdate,
      Key? key})
      : _left = left,
        _top = top,
        _markerSize = markerSize,
        _onPanUpdate = onPanUpdate,
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
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
