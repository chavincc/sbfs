import 'package:flutter/material.dart';
import '../providers/faces.dart';

class AffectedSideInput extends StatelessWidget {
  final AffectedSide? _value;
  final void Function(AffectedSide)? _onSelectCallback;

  const AffectedSideInput({
    required AffectedSide? value,
    void Function(AffectedSide)? onSelectCallback,
    Key? key,
  })  : _value = value,
        _onSelectCallback = onSelectCallback,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Affected side :',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            InkWell(
              onTap: _onSelectCallback == null
                  ? null
                  : () {
                      _onSelectCallback!(AffectedSide.left);
                    },
              child: IgnorePointer(
                child: Row(
                  children: [
                    Checkbox(
                      value: _value == AffectedSide.left,
                      onChanged: (_) {},
                    ),
                    const Text(
                      'L',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: _onSelectCallback == null
                  ? null
                  : () {
                      _onSelectCallback!(AffectedSide.right);
                    },
              child: IgnorePointer(
                child: Row(
                  children: [
                    Checkbox(
                      value: _value == AffectedSide.right,
                      onChanged: (_) {},
                    ),
                    const Text(
                      'R',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
