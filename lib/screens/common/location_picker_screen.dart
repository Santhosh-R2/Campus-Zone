import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng _selectedLocation = const LatLng(12.9716, 77.5946); // Default: Bangalore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Home Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, _selectedLocation);
            },
          )
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: _selectedLocation,
          zoom: 13,
          onTap: (tapPosition, point) {
            setState(() {
              _selectedLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
             userAgentPackageName: 'com.example.smart_collage',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _selectedLocation,
                width: 80,
                height: 80,
                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           Navigator.pop(context, _selectedLocation);
        },
        label: const Text('Confirm Location'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
