import 'package:pdf/widgets.dart' as pw;

pw.Widget buildKeyValueText(String key, String value) {
  return pw.Container(
    width: double.infinity,
    margin: const pw.EdgeInsets.only(bottom: 10),
    child: pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '$key : ',
            style: const pw.TextStyle(
              fontSize: 18,
            ),
          ),
          pw.TextSpan(
            text: value,
            style: pw.TextStyle(
              fontSize: 18,
              fontStyle: pw.FontStyle.italic,
            ),
          ),
        ],
      ),
    ),
  );
}
