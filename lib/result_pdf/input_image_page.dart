import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../providers/faces.dart';
import './page_title.dart';
import './key_value_text.dart';

const double boxSize = 180;

pw.Page buildInputImagePagePdf(
  Map<Poses, File?> posesPhoto,
  String? patientId,
  AffectedSide? affectedSide,
  bool haveEyeSurgery,
) {
  final strAffectedSide = (affectedSide != null)
      ? (affectedSide == AffectedSide.left)
          ? 'L'
          : 'R'
      : 'unknown';
  final strHaveEyeSurgery = haveEyeSurgery ? 'Yes' : 'No';

  return pw.Page(
    pageFormat: PdfPageFormat.a4,
    build: (pw.Context context) {
      return pw.Column(
        children: [
          buildPageTitle('Patient Input'),
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 25),
            child: pw.Column(
              children: [
                buildKeyValueText('Patient Id', patientId ?? 'unknown'),
                buildKeyValueText('Affected side', strAffectedSide),
                buildKeyValueText('Eye surgery', strHaveEyeSurgery),
              ],
            ),
          ),
          buildPoseImageRow([
            buildPoseImageItem(
              posesPhoto[Poses.resting],
              'Resting',
            ),
            buildPoseImageItem(
              posesPhoto[Poses.browLift],
              'Brow Lift',
            ),
            buildPoseImageItem(
              posesPhoto[Poses.eyesClose],
              'Gentle Eyes Closure',
            ),
          ]),
          buildPoseImageRow([
            buildPoseImageItem(
              posesPhoto[Poses.smile],
              'Open Mouth Smile',
            ),
            buildPoseImageItem(
              posesPhoto[Poses.snarl],
              'Snarl',
            ),
            buildPoseImageItem(
              posesPhoto[Poses.lipPucker],
              'Lip Pucker',
            ),
          ]),
        ],
      );
    },
  );
}

// row styling wrapper
pw.Widget buildPoseImageRow(List<pw.Widget> children) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 50),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: children,
    ),
  );
}

pw.Widget buildPoseImageItem(File? poseImage, String poseName) {
  // empty state rendering
  pw.Widget renderedImageWidget = pw.Container(
    width: boxSize,
    height: boxSize,
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.grey),
      color: PdfColors.grey300,
    ),
    alignment: pw.Alignment.center,
    child: pw.Text('no image'),
  );

  // render image instead if it exists
  if (poseImage != null) {
    final memoryImage = pw.MemoryImage(poseImage.readAsBytesSync());
    renderedImageWidget = pw.Container(
      height: boxSize,
      width: boxSize,
      child: pw.Image(memoryImage),
    );
  }
  return pw.Column(
    children: [
      pw.SizedBox(
        width: boxSize,
        child: pw.Text(
          poseName,
          style: const pw.TextStyle(fontSize: 18),
        ),
      ),
      renderedImageWidget,
    ],
  );
}
