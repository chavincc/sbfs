import '../models/size.dart';
import '../providers/landmarks.dart';

// function to convert coordinate value between [0,1]
// (per image dimension) to actual pixel on image
void denormalizeCoord(
  Coord c,
  Size imageDimension,
  double markerSize,
  double markerPadding,
) {
  c.x = (c.x * imageDimension.width) - (markerSize / 2) - (markerPadding);
  c.y = (c.y * imageDimension.height) - (markerSize / 2) - (markerPadding);
}

void normalizeCoord(
  Coord c,
  Size imageDimension,
  double markerSize,
  double markerPadding,
) {
  c.x = (c.x + markerPadding + markerSize / 2) / imageDimension.width;
  c.y = (c.y + markerPadding + markerSize / 2) / imageDimension.height;
}
