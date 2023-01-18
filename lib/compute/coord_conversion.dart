import '../models/size.dart';
import '../providers/landmarks.dart';

// function to convert coordinate value between [0,1]
// (per image dimension) to actual pixel on image
void denormalizeCoord(Coord c, Size imageDimension, double markerSize) {
  c.x = (c.x * imageDimension.width) - (markerSize / 2);
  c.y = (c.y * imageDimension.height) - (markerSize / 2);
}

void normalizeCoord(Coord c, Size imageDimension, double markerSize) {
  c.x = (c.x + markerSize / 2) / imageDimension.width;
  c.y = (c.y + markerSize / 2) / imageDimension.height;
}
