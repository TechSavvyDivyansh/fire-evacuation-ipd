// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, use_super_parameters, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';

class FloorMapWidget extends StatefulWidget {
  final double personX, personY;
  final double exitX, exitY;
  final double? fireX, fireY;
  final List<List<double>> path;

  const FloorMapWidget({
    required this.personX,
    required this.personY,
    required this.exitX,
    required this.exitY,
    this.fireX,
    this.fireY,
    required this.path,
    Key? key,
  }) : super(key: key);

  @override
  _FloorMapWidgetState createState() => _FloorMapWidgetState();
}

class _FloorMapWidgetState extends State<FloorMapWidget> {
  late double _personX;
  late double _personY;
  late double _exitX;
  late double _exitY;
  double? _fireX;
  double? _fireY;
  List<List<double>> _path = [];

  @override
  void initState() {
    super.initState();
    _personX = widget.personX;
    _personY = widget.personY;
    _exitX = widget.exitX;
    _exitY = widget.exitY;
    _fireX = widget.fireX;
    _fireY = widget.fireY;
    _path = widget.path;
  }

  @override
  void didUpdateWidget(FloorMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _personX = widget.personX;
      _personY = widget.personY;
      _exitX = widget.exitX;
      _exitY = widget.exitY;
      _fireX = widget.fireX;
      _fireY = widget.fireY;
      _path = widget.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 980,
        height: 500,
        child: CustomPaint(
          painter: MapPainter(
            x: _personX,
            y: _personY,
            exitX: _exitX,
            exitY: _exitY,
            fireX: _fireX,
            fireY: _fireY,
            path: _path,
          ),
        ),
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  final double x, y;
  final double exitX, exitY;
  final double? fireX, fireY;
  final List<List<double>> path;

  MapPainter({
    required this.x,
    required this.y,
    required this.exitX,
    required this.exitY,
    this.fireX,
    this.fireY,
    required this.path,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()..color = Colors.grey[200]!;

    TextPainter drawText(String text, Offset offset, {double fontSize = 10}) {
      final textSpan = TextSpan(
        text: text,
        style: TextStyle(color: Colors.black, fontSize: fontSize),
      );
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, offset);
      return tp;
    }

    void drawRoom(Rect rect, String label) {
      canvas.drawRect(rect, fillPaint);
      canvas.drawRect(rect, paint);
      drawText(label, Offset(rect.left + 5, rect.top + 5));
    }

    // Draw rooms
    drawRoom(Rect.fromLTWH(20, 50, 180, 100), 'Stairway 1');
    drawRoom(Rect.fromLTWH(350, 50, 100, 60), 'Elevator 1');
    drawRoom(Rect.fromLTWH(350, 110, 100, 60), 'Elevator 2');
    drawRoom(Rect.fromLTWH(300, 200, 130, 100), 'Staff Room');
    drawRoom(Rect.fromLTWH(430, 200, 145, 100), '61');
    drawRoom(Rect.fromLTWH(575, 200, 145, 100), '62');
    drawRoom(Rect.fromLTWH(720, 200, 145, 100), '63');
    drawRoom(Rect.fromLTWH(880, 200, 100, 100), 'Stairway 2');
    drawRoom(Rect.fromLTWH(100, 200, 120, 100), 'L1');
    drawRoom(Rect.fromLTWH(20, 300, 80, 100), 'HOD\nCABIN');
    drawRoom(Rect.fromLTWH(100, 400, 100, 100), 'L2');
    drawRoom(Rect.fromLTWH(200, 400, 100, 100), 'L3');
    drawRoom(Rect.fromLTWH(300, 400, 100, 100), 'L4');
    drawRoom(Rect.fromLTWH(400, 400, 100, 100), 'L5');
    drawRoom(Rect.fromLTWH(500, 400, 100, 100), 'L6');
    drawRoom(Rect.fromLTWH(600, 400, 100, 100), 'Staff\nLounge');
    drawRoom(Rect.fromLTWH(700, 400, 70, 100), 'Store\nRoom');
    drawRoom(Rect.fromLTWH(770, 400, 50, 100), 'HER');
    drawRoom(Rect.fromLTWH(820, 400, 50, 100), 'HIS');
    drawRoom(Rect.fromLTWH(880, 480, 100, 20), 'Elevator 3');

    // 🔵 Person marker
    final personPaint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(x, y), 10, personPaint);
    drawText('Person', Offset(x + 12, y));

    // ✅ Exit Marker
    final exitPaint = Paint()..color = Colors.green;
    canvas.drawCircle(Offset(exitX, exitY), 15, exitPaint);
    drawText('Exit', Offset(exitX + 10, exitY - 5));

    // 🔥 Fire Marker (reddish-orange)
    if (fireX != null && fireY != null) {
      final firePaint = Paint()..color = Colors.deepOrange;
      canvas.drawCircle(Offset(fireX!, fireY!), 15, firePaint);
    }

    // 🔷 Path Line Drawing
    if (path.isNotEmpty) {
      final pathPaint = Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 3.0;

      final pathPoints = [Offset(x, y)] +
          path.map((point) => Offset(point[0], point[1])).toList();

      for (int i = 0; i < pathPoints.length - 1; i++) {
        canvas.drawLine(pathPoints[i], pathPoints[i + 1], pathPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
