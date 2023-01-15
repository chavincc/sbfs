import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sbfs/models/scores.dart';

import '../providers/scores.dart';
import './page_title.dart';
import './key_value_text.dart';

pw.Page buildComputedScorePage(
  ScoreInstance sunnyBrookScore,
  int restingTotalScore,
  int voluntaryMovementTotalScore,
  int synkinesisTotalScore,
) {
  pw.Widget pageTitle = buildPageTitle('Computed score');

  final contentWidth = PdfPageFormat.a4.availableWidth;

  return pw.Page(
    pageFormat: PdfPageFormat.a4,
    build: (pw.Context context) {
      return pw.Column(
        children: [
          pageTitle,
          buildScoreRow(
            [
              buildScoreColumn(
                contentWidth,
                [
                  buildScoreGroupTitle('Resting'),
                  buildScoreGroupSummary('total = $restingTotalScore'),
                  buildKeyValueText('Eye', sunnyBrookScore['Eye'].toString()),
                  buildKeyValueText(
                      'Nasolabial', sunnyBrookScore['Nasolabial'].toString()),
                  buildKeyValueText(
                      'Mouth', sunnyBrookScore['Mouth'].toString()),
                ],
              ),
              buildScoreColumn(
                contentWidth,
                [
                  buildScoreGroupTitle('Voluntary Movement'),
                  buildScoreGroupSummary(
                      'total = $voluntaryMovementTotalScore'),
                  buildKeyValueText(
                      'Brow Lift', sunnyBrookScore['Brow Lift'].toString()),
                  buildKeyValueText('Gentle Eye Closure',
                      sunnyBrookScore['Gentle Eye Closure'].toString()),
                  buildKeyValueText('Open Mouth Smile',
                      sunnyBrookScore['Open Mouth Smile'].toString()),
                  buildKeyValueText(
                      'Snarl', sunnyBrookScore['Snarl'].toString()),
                  buildKeyValueText(
                      'Lip Pucker', sunnyBrookScore['Lip Pucker'].toString()),
                ],
              ),
            ],
          ),
          buildScoreRow(
            [
              buildScoreColumn(
                contentWidth,
                [
                  buildScoreGroupTitle('Synkinesis'),
                  buildScoreGroupSummary('total = $synkinesisTotalScore'),
                  buildKeyValueText('Brow Lift',
                      sunnyBrookScore['Brow Lift Synkinesis'].toString()),
                  buildKeyValueText(
                      'Gentle Eye Closure',
                      sunnyBrookScore['Gentle Eye Closure Synkinesis']
                          .toString()),
                  buildKeyValueText(
                      'Open Mouth Smile',
                      sunnyBrookScore['Open Mouth Smile Synkinesis']
                          .toString()),
                  buildKeyValueText(
                      'Snarl', sunnyBrookScore['Snarl Synkinesis'].toString()),
                  buildKeyValueText('Lip Pucker',
                      sunnyBrookScore['Lip Pucker Synkinesis'].toString()),
                ],
              ),
              buildScoreColumn(
                contentWidth,
                [
                  buildScoreGroupTitle('Composite Score'),
                  buildHighlightWrapper(
                    buildKeyValueText('total',
                        '${voluntaryMovementTotalScore * 4 - restingTotalScore * 5 - synkinesisTotalScore}'),
                  ),
                ],
              ),
            ],
          )
        ],
      );
    },
  );
}

// row styling wrapper
pw.Widget buildScoreRow(List<pw.Widget> children) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 40),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: children,
    ),
  );
}

// highlight container wrapper
pw.Widget buildHighlightWrapper(pw.Widget child) {
  return pw.Container(
    padding: const pw.EdgeInsets.only(
      top: 10,
      left: 10,
    ),
    decoration: pw.BoxDecoration(
      color: PdfColor.fromHex('#ADD8E6'),
      borderRadius: const pw.BorderRadius.all(
        pw.Radius.circular(5),
      ),
    ),
    child: child,
  );
}

pw.Widget buildScoreGroupSummary(String summary) {
  return pw.Container(
    width: double.infinity,
    margin: const pw.EdgeInsets.only(bottom: 10),
    child: pw.Text(
      summary,
      style: pw.TextStyle(
        fontSize: 18,
        color: PdfColor.fromHex('#1397bf'),
      ),
    ),
  );
}

pw.Widget buildScoreColumn(
  double availableWidth,
  List<pw.Widget> children,
) {
  return pw.Container(
    width: availableWidth / 2,
    child: pw.Column(
      children: children,
    ),
  );
}

pw.Widget buildScoreGroupTitle(String groupTitle) {
  return pw.Container(
    width: double.infinity,
    margin: const pw.EdgeInsets.only(bottom: 20),
    child: pw.Text(
      groupTitle,
      style: const pw.TextStyle(
        fontSize: 22,
        decoration: pw.TextDecoration.underline,
      ),
    ),
  );
}
