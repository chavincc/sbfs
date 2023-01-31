import '../models/size.dart';

// return actual [width, height] of camera displayed on screen
Size getCameraRenderedSize({
  required double previewWidth,
  required double previewHeight,
  required double screenWidth,
  required double screenHeight,
}) {
  final zeroCheck = previewHeight == 0 || screenHeight == 0;
  if (zeroCheck) return Size(width: 0, height: 0);

  final previewRatio = previewWidth / previewHeight;
  final screenRatio = screenWidth / screenHeight;
  if (previewRatio > screenRatio) {
    return Size(width: screenWidth, height: screenWidth / previewRatio);
  } else {
    return Size(width: screenHeight * previewRatio, height: screenHeight);
  }
}

// get face guide rendered height for padding calculation
// face guide width will be forced by its container
// and its height will be ratio'd
double getFaceGuideRenderedHeight({
  required Size originalFaceGuideSize,
  required double cameraRenderedWidth,
  required double faceGuideWidthRatio,
}) {
  final faceGuideContainerWidth = cameraRenderedWidth * faceGuideWidthRatio;
  final scaling = faceGuideContainerWidth / originalFaceGuideSize.width;
  final renderedFaceGuideHeight = originalFaceGuideSize.height * scaling;
  return renderedFaceGuideHeight;
}
