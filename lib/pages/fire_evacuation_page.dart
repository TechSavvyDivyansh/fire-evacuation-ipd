// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:app/utils/semicirclular_clipper.dart';
import 'package:app/components/working_camera.dart';

class FireEvacuationPage extends StatefulWidget {
  const FireEvacuationPage({super.key});

  @override
  State<FireEvacuationPage> createState() => _FireEvacuationPageState();
}

class _FireEvacuationPageState extends State<FireEvacuationPage> {
  final CameraService cameraService = CameraService();
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await cameraService.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (isCameraInitialized && cameraService.cameraController != null)
            CameraPreview(cameraService.cameraController!)
          else
            Center(child: CircularProgressIndicator()),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: SemicircleClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image.png'),
                    fit: BoxFit.cover,
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