import 'package:at_location_flutter/common_components/circle_marker_painter.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/material.dart';

Widget createMarker({
  required double diameterOfCircle,
  double heightOfMarker = 50,
  double widthOfMarker = 40,
}) {
  if (diameterOfCircle < 100) {
    switch (diameterOfCircle.toInt()) {
      case 2:
        diameterOfCircle = 100;
        break;
      case 5:
        diameterOfCircle = 200;
        break;
      case 10:
        diameterOfCircle = 300;
        break;
      default:
        diameterOfCircle = 100;
        break;
    }
  }

  /// bottomOfCircle = (((bottom of icon + (size of icon/2))*2 - height of circle)) / 2
  double bottomOfCircle = ((((heightOfMarker / 2) + (widthOfMarker / 2)) * 2 - diameterOfCircle)) / 2;

  /// leftOfCircle = (size of icon - width of circle)/2
  double leftOfCircle = (widthOfMarker - diameterOfCircle) / 2;

  return Stack(
    clipBehavior: Clip.none,
    children: [
      Positioned(
        bottom: heightOfMarker / 2, // height/2 => so, it starts from center
        child: Icon(
          Icons.location_on,
          color: ColorConstants.orange,
          size: widthOfMarker, // same as width of marker
        ),
      ),
      Positioned(
        // 25 + 20 (bottom + size/2) for center
        bottom: bottomOfCircle, // ((25 + (20))*2 - 200) => ((bottom of icon + (size of icon/2))*2 - heightof circle)
        left: leftOfCircle, // (40-200)/2 => (size of icon - width of circle)/2
        child: SizedBox(
          width: diameterOfCircle,
          height: diameterOfCircle,
          child: CustomPaint(
            painter:
                CircleMarkerPainter(color: const Color(0xFFF47B5D).withOpacity(0.2), paintingStyle: PaintingStyle.fill),
          ),
        ),
      ),
    ],
  );
}
