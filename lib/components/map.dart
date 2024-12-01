// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:app/utils/semicirclular_clipper.dart';
class MapWidget extends StatelessWidget {
  const MapWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.40;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipPath(
            clipper: SemicircleClipper(),
            child: Container(
              width: width,
              height: height,
              color: Colors.blue,
            ),
          ),
          // WebView with semicircle shape
          ClipPath(
            clipper: SemicircleClipper(),
            child: Container(
              width: width,
              height: height,
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(
                    'https://app.mappedin.com/map/67403037ed01dd000b415691',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}