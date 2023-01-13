import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:sbfs/models/scores.dart';

import '../providers/faces.dart';
import './input_image_page.dart';
import './computed_score_page.dart';

pw.Document buildResultPdf(
  Map<Poses, File?> posesPhoto,
  String? patientId,
  AffectedSide? affectedSide,
  bool haveEyeSurgery,
  ScoreInstance sunnyBrookScore,
  int restingTotalScore,
  int voluntaryMovementTotalScore,
  int synkinesisTotalScore,
) {
  final pdf = pw.Document();

  final inputImagePage = buildInputImagePagePdf(
    posesPhoto,
    patientId,
    affectedSide,
    haveEyeSurgery,
  );

  final computedScorePage = buildComputedScorePage(
    sunnyBrookScore,
    restingTotalScore,
    voluntaryMovementTotalScore,
    synkinesisTotalScore,
  );

  pdf.addPage(inputImagePage);
  pdf.addPage(computedScorePage);
  return pdf;
}
