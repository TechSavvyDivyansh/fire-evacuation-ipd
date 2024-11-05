import 'package:flutter/material.dart';

class SemicircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height * 0.4);

    path.quadraticBezierTo(
      size.width / 2,
      0,
      size.width,
      size.height * 0.4,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
