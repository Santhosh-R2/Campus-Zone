import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// Note: In a real app we would use the 'latlong2' and 'flutter_map' packages properly
// For this demo, we will show a list of stops.

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route to Institute')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(leading: Icon(Icons.location_on, color: Colors.green), title: Text('Institute (Start)')),
          ListTile(leading: Icon(Icons.linear_scale), title: Text('Stop 1: Central Station')),
          ListTile(leading: Icon(Icons.linear_scale), title: Text('Stop 2: Main Market')),
          ListTile(leading: Icon(Icons.linear_scale), title: Text('Stop 3: Housing Board')),
          ListTile(leading: Icon(Icons.flag, color: Colors.red), title: Text('Institute (End)')),
        ],
      ),
    );
  }
}
