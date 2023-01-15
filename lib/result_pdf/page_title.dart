import 'package:pdf/widgets.dart' as pw;

pw.Widget buildPageTitle(String title) {
  return pw.Container(
    width: double.infinity,
    margin: const pw.EdgeInsets.only(bottom: 25),
    child: pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 25,
        decoration: pw.TextDecoration.underline,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );
}
