import 'package:flutter/material.dart';

class GridBackground extends StatelessWidget {
  const GridBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridPainter(),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color.fromARGB(17, 169, 169, 169)
      ..strokeWidth = 1;

    for (int i = 0; i <= size.width.toInt(); i += 20) {
      canvas.drawLine(Offset(i.toDouble(), 0),
          Offset(i.toDouble(), size.height), gridPaint);
    }

    for (int i = 0; i <= size.height.toInt(); i += 20) {
      canvas.drawLine(
          Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), gridPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
