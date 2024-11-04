// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:app/components/evacuate_button.dart';
import 'package:app/pages/fire_evacuation_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 5),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://img.freepik.com/premium-photo/cute-boy-firefighter-with-water-hose-cartoon-profession-icon_839035-1216222.jpg',
              ),
              radius: 25,
            ),
          )
        ],
      ),
      body: Center(
        child: Container(
          child: EvacuateButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FireEvacuationPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
