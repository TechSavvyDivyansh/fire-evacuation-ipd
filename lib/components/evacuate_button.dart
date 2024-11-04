// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class EvacuateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EvacuateButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF80F0F),
                Color(0xFF950000),
              ],
            ),
            boxShadow: [
              // Top-left shadow
              BoxShadow(
                color: Color.fromARGB(255, 167, 1, 1),
                offset: const Offset(0, 0),
                blurRadius: 20,
              ),
              // Bottom-right shadow
            ],
          ),
          width: 250,
          height: 250,
          child: const Center(
            child: Text(
              "EVACUATE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,  
              ),
            ),
          ),
        ),
      ),
    );
  }
}
