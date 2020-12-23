import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

import 'human_body.dart';
import 'parser.dart';

class PathPainter extends CustomPainter {
  final BuildContext context;
  final List<Path> paths;
  final List<PathSegment> segments;
  final List<Path> curPaths;
  final Function(Path curPath, TapDownDetails tapDownDetails, String pathName)
      onPressed;
  final bool selectedPartWithHighlight;
  PathPainter({
    this.context,
    this.paths,
    this.curPaths,
    this.onPressed,
    this.segments,
    this.selectedPartWithHighlight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // calculate the scale factor, use the min value
    final xScale = size.width / svgWidth;
    final yScale = size.height / svgHeight;
    final scale = xScale < yScale ? xScale : yScale;

    // scale each path to match canvas size
    final matrix4 = Matrix4.identity();
    matrix4.scale(scale, scale);

    // calculate the scaled svg image width and height
    // in order to get right offset
    var scaledSvgWidth = svgWidth * scale;
    var scaledSvgHeight = svgHeight * scale;
    // calculate offset to center the svg image
    var offsetX = (size.width - scaledSvgWidth) / 2;
    var offsetY = (size.height - scaledSvgHeight) / 2;

    final touchCanvas = TouchyCanvas(context, canvas);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 1.0;

    for (var i = 0; i <= paths.length - 1; i++) {
      if (selectedPartWithHighlight == true) {
        paint.style =
            curPaths.contains(paths[i]) ? PaintingStyle.fill : PaintingStyle.stroke;
      }

      touchCanvas.drawPath(
        paths[i].transform(matrix4.storage).shift(Offset(offsetX, offsetY)),
        paint,
        onTapDown: (details) {
          onPressed(paths[i], details, segments[i].pathname);
          print(segments[i].pathname);
        },
      );
    }
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => true;
}
