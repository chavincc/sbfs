import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextCopyDisplay extends StatelessWidget {
  final String _label;
  final String _value;

  const TextCopyDisplay(
      {required String label, required String value, Key? key})
      : _label = label,
        _value = value,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$_label : $_value',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Clipboard.setData(
              ClipboardData(text: _value),
            );
            const snackBar = SnackBar(
              content: Text('copied to clipboard'),
            );
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade700,
          ),
          child: const Text('copy'),
        )
      ],
    );
  }
}
