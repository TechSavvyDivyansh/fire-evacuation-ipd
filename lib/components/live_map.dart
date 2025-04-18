import 'package:app/components/FloorMapWidget.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:http/http.dart' as http;

class LiveMap extends StatefulWidget {
  const LiveMap({super.key});

  @override
  State<LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  late IO.Socket socket;
  double personX = 0;
  double personY = 0;
  double exitX = 930;
  double exitY = 300;
  double? fireX;
  double? fireY;
  List<List<double>> path = [];

  @override
  void initState() {
    super.initState();
    connectToSocket();
    fetchFireLocation();
  }

  void connectToSocket() {
    socket = IO.io(
      'http://192.168.1.9:5000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionDelay(500)
          .build(),
    );

    socket.onConnect((_) => print('✅ Connected to socket'));
    socket.onDisconnect((_) => print('❌ Disconnected'));

    socket.on('personMoved', (data) {
      setState(() {
        personX = data['x']?.toDouble() ?? 0;
        personY = data['y']?.toDouble() ?? 0;
      });
      calculatePath(personX, personY);
    });
  }

  Future<void> calculatePath(double x, double y) async {
    final uri = Uri.parse('http://192.168.1.9:5000/calculate-path');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'x': x, 'y': y}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final exit = result['exit'];
        final rawPath = result['path'];

        if (exit != null && exit['x'] != null && exit['y'] != null) {
          setState(() {
            exitX = exit['x'].toDouble();
            exitY = exit['y'].toDouble();

            // ✅ Store path as List<List<double>>
            path = (rawPath as List)
                .skip(1)
                .map<List<double>>((p) => [p[0].toDouble(), p[1].toDouble()])
                .toList();
          });
        }
      }
    } catch (e) {
      print('🚨 Error in calculatePath: $e');
    }
  }

  Future<void> fetchFireLocation() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.9:5000/get-fire'));
      if (response.statusCode == 200) {
        final fire = jsonDecode(response.body);
        if (fire is List && fire.length >= 2) {
          setState(() {
            fireX = fire[0].toDouble();
            fireY = fire[1].toDouble();
            print('🔥 Fire location: ($fireX, $fireY)');
          });
        }
      }
    } catch (e) {
      print('🔥 Error fetching fire location: $e');
    }
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 980,
      height: 300,
      child: FloorMapWidget(
        personX: personX,
        personY: personY,
        exitX: exitX,
        exitY: exitY,
        fireX: fireX,
        fireY: fireY,
        path: path,
      ),
    );
  }
}
