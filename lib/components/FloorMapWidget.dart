// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations, library_private_types_in_public_api, file_names

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
    super.key,
  });

  @override
  _FloorMapWidgetState createState() => _FloorMapWidgetState();
}

class _FloorMapWidgetState extends State<FloorMapWidget>
    with SingleTickerProviderStateMixin {
  late double _personX;
  late double _personY;
  late double _exitX;
  late double _exitY;
  double? _fireX;
  double? _fireY;
  List<List<double>> _path = [];
  late AnimationController _animationController;
  late Animation<double> _animation;

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

    // Animation for pulsing effects
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 980,
            height: 500,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: MapPainter(
                    x: _personX,
                    y: _personY,
                    exitX: _exitX,
                    exitY: _exitY,
                    fireX: _fireX,
                    fireY: _fireY,
                    path: _path,
                    pulseValue: _animation.value,
                  ),
                );
              },
            ),
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
  final double pulseValue;

  MapPainter({
    required this.x,
    required this.y,
    required this.exitX,
    required this.exitY,
    this.fireX,
    this.fireY,
    required this.path,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 0)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Grid lines for visual reference with better spacing
    // final gridPaint = Paint()
    //   ..color = const Color.fromRGBO(169, 169, 169, 0.15)
    //   ..strokeWidth = 1;

    // // Draw horizontal grid lines with appropriate spacing
    // for (int i = 0; i <= size.width.toInt(); i += 50) {
    //   canvas.drawLine(Offset(i.toDouble(), 0),
    //       Offset(i.toDouble(), size.height), gridPaint);
    // }

    // // Draw vertical grid lines with appropriate spacing
    // for (int i = 0; i <= size.height.toInt(); i += 50) {
    //   canvas.drawLine(
    //       Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), gridPaint);
    // }
    // for (int i = 0; i < size.height; i += 50) {
    //   canvas.drawLine(
    //       Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), gridPaint);
    // }

    // Room styling
    final roomStrokePaint = Paint()
      ..color = const Color(0xFF495057)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Function to generate room colors based on their purpose
    Color getRoomColor(String label) {
      if (label.contains('Stairway')) {
        return const Color(0xFFE3F2FD); // Light blue for stairways
      } else if (label.contains('Elevator')) {
        return const Color(0xFFFFECB3); // Light amber for elevators
      } else if (label.contains('Staff')) {
        return const Color(0xFFE8F5E9); // Light green for staff areas
      } else if (label.contains('L')) {
        return const Color(0xFFEDE7F6); // Light purple for L rooms
      } else if (label.contains('Store')) {
        return const Color(0xFFFFEBEE); // Light red for storage
      } else if (label.contains('HER') || label.contains('HIS')) {
        return const Color(0xFFE0F7FA); // Light cyan for restrooms
      } else {
        return const Color(0xFFF5F5F5); // Light grey for other rooms
      }
    }

    TextPainter drawText(String text, Offset offset,
        {double fontSize = 12, Color? color}) {
      final textSpan = TextSpan(
        text: text,
        style: TextStyle(
          color: color ?? const Color(0xFF212529),
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      );
      final tp = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      tp.layout();
      tp.paint(canvas, offset);
      return tp;
    }

    void drawRoom(Rect rect, String label) {
      final color = getRoomColor(label);
      final fillPaint = Paint()..color = color;

      // Draw room with rounded corners
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
      canvas.drawRRect(rrect, fillPaint);
      canvas.drawRRect(rrect, roomStrokePaint);

      // Create TextPainter to precisely measure text dimensions
      final textSpan = TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF212529),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      // Layout the text to get its dimensions
      textPainter.layout(maxWidth: rect.width - 10);

      // Calculate centering position
      final textX = rect.left + (rect.width - textPainter.width) / 2;
      final textY = rect.top + (rect.height - textPainter.height) / 2;

      // Draw the text
      textPainter.paint(canvas, Offset(textX, textY));
    }

    // Draw rooms with better spacing and soft colors
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

    // Path Line Drawing with smoother curves and vibrant color
    if (path.isNotEmpty) {
      final pathPaint = Paint()
        ..color = const Color(0xFF4A89DC)
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round;

      final pathOutlinePaint = Paint()
        ..color = Color.fromRGBO(255, 255, 255, 0.6)
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.round;

      final pathPoints = [Offset(x, y)] +
          path.map((point) => Offset(point[0], point[1])).toList();

      // Draw white outline first for a glowing effect
      for (int i = 0; i < pathPoints.length - 1; i++) {
        canvas.drawLine(pathPoints[i], pathPoints[i + 1], pathOutlinePaint);
      }

      // Draw the actual path
      for (int i = 0; i < pathPoints.length - 1; i++) {
        canvas.drawLine(pathPoints[i], pathPoints[i + 1], pathPaint);
      }

      // Draw small circles at path vertices for better visibility
      final pathNodePaint = Paint()
        ..color = const Color(0xFF4A89DC)
        ..style = PaintingStyle.fill;

      for (int i = 1; i < pathPoints.length - 1; i++) {
        canvas.drawCircle(pathPoints[i], 3, pathNodePaint);
      }
    }

    // 🔵 Person marker with enhanced glowing effect
    final personPaint = Paint()
      ..color = Color.fromRGBO(0, 0, 255, pulseValue * 0.8)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.0 * pulseValue);

    final personCenterPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), 14 * pulseValue, personPaint);
    canvas.drawCircle(Offset(x, y), 8, personCenterPaint);
    canvas.drawCircle(
        Offset(x, y),
        8,
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    // ✅ Exit Marker with enhanced gradient effect
    final exitOuterPaint = Paint()
      ..color = Color.fromRGBO(0, 255, 0, pulseValue * 0.5)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.0);

    final exitPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.green.shade300, Colors.green.shade600],
        center: Alignment.center,
        radius: 0.5,
      ).createShader(Rect.fromCircle(center: Offset(exitX, exitY), radius: 20));

    canvas.drawCircle(Offset(exitX, exitY), 22 * pulseValue, exitOuterPaint);
    canvas.drawCircle(Offset(exitX, exitY), 16, exitPaint);

    // Exit icon
    final exitPath = Path();
    exitPath.moveTo(exitX - 8, exitY - 2);
    exitPath.lineTo(exitX - 2, exitY + 4);
    exitPath.lineTo(exitX + 8, exitY - 8);

    canvas.drawPath(
        exitPath,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round);

    // 🔥 Fire Marker with enhanced glowing effect
    if (fireX != null && fireY != null) {
      // Outer glow
      final fireOuterPaint = Paint()
        ..color = Color.fromRGBO(255, 0, 0, pulseValue * 0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12.0);

      // Inner gradient
      final firePaint = Paint()
        ..shader = RadialGradient(
          colors: [Colors.yellow, Colors.orange, Colors.red],
          stops: const [0.2, 0.5, 0.8],
        ).createShader(
            Rect.fromCircle(center: Offset(fireX!, fireY!), radius: 18));

      canvas.drawCircle(
          Offset(fireX!, fireY!), 28 * pulseValue, fireOuterPaint);
      canvas.drawCircle(Offset(fireX!, fireY!), 18, firePaint);
    }

    // Draw a compass rose in the bottom right corner
    final compassCenterX = size.width - 60;
    final compassCenterY = size.height - 60;
    final compassRadius = 30.0;

    // Compass background
    final compassBg = Paint()
      ..color = Color.fromRGBO(255, 255, 255, 0.8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(compassCenterX, compassCenterY), compassRadius, compassBg);
    canvas.drawCircle(
        Offset(compassCenterX, compassCenterY),
        compassRadius,
        Paint()
          ..color = Color.fromRGBO(169, 169, 169, 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0);

    // Compass directions
    drawText('N', Offset(compassCenterX - 5, compassCenterY - 25),
        fontSize: 14, color: Colors.red[700]);
    drawText('S', Offset(compassCenterX - 5, compassCenterY + 15),
        fontSize: 14);
    drawText('E', Offset(compassCenterX + 15, compassCenterY - 5),
        fontSize: 14);
    drawText('W', Offset(compassCenterX - 25, compassCenterY - 5),
        fontSize: 14);

    // Compass needle
    final needlePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(compassCenterX, compassCenterY),
        Offset(compassCenterX, compassCenterY - 10), needlePaint);

    canvas.drawLine(
        Offset(compassCenterX, compassCenterY),
        Offset(compassCenterX, compassCenterY + 10),
        Paint()
          ..color = Colors.black54
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
