import 'package:flutter/material.dart';

class FaceMarker extends StatelessWidget {
  final double _left;
  final double _top;
  final double _markerSize;
  final double _markerInvisPadding;
  final void Function(DragUpdateDetails)? _onPanUpdate;
  final Color _color;
  final int? _mpid;

  const FaceMarker(
      {required double left,
      required double top,
      required double markerSize,
      required double markerInvisPadding,
      void Function(DragUpdateDetails)? onPanUpdate,
      Color color = Colors.black,
      int? mpid,
      Key? key})
      : _left = left,
        _top = top,
        _markerSize = markerSize,
        _markerInvisPadding = markerInvisPadding,
        _onPanUpdate = onPanUpdate,
        _color = color,
        _mpid = mpid,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left,
      top: _top,
      child: GestureDetector(
          onPanUpdate: _onPanUpdate,
          child: Row(
            children: [
              Container(
                width: _markerSize.toDouble() + (_markerInvisPadding * 2),
                height: _markerSize.toDouble() + (_markerInvisPadding * 2),
                padding: EdgeInsets.all(_markerInvisPadding),
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
              _mpid != null
                  ? Text(
                      _mpid!.toString(),
                      style: const TextStyle(
                        fontSize: 7.5,
                      ),
                    )
                  : Container(),
            ],
          )),
    );
  }
}
