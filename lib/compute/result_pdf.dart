import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:sbfs/result_pdf/input_image_page.dart';

import '../providers/faces.dart';

pw.Document buildResultPdf(
  Map<Poses, File?> posesPhoto,
  String? patientId,
  AffectedSide? affectedSide,
  bool haveEyeSurgery,
) {
  final pdf = pw.Document();

  final inputImagePage = buildInputImagePagePdf(
    posesPhoto,
    patientId,
    affectedSide,
    haveEyeSurgery,
  );

  pdf.addPage(inputImagePage);
  return pdf;
}
