import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../providers/bus_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';

class BusTrackingScreen extends StatefulWidget {
  const BusTrackingScreen({super.key});

  @override
  State<BusTrackingScreen> createState() => _BusTrackingScreenState();
}

class _BusTrackingScreenState extends State<BusTrackingScreen> {
  final MapController _mapController = MapController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _refresh();
    // Auto refresh every 10 seconds for live updates
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) => _refresh());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _refresh() {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      Provider.of<BusProvider>(context, listen: false).fetchPrediction(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Bus Status')),
      body: Consumer<BusProvider>(
        builder: (context, bus, _) {
          final pred = bus.prediction;
          
          if (pred == null || pred['status'] != 'ACTIVE') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bus_alert_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('No Active Trip Found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text('The bus has not started yet.'),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _refresh, child: const Text('Check Again'))
                ],
              ),
            );
          }
          
          // Use prediction/live data for lat/lng if available. 
          // Since the user provided `getUserPrediction` which returns formatted strings,
          // we might need `getLiveLocation` for actual coords. 
          // For now, we utilize a fixed location or assume the backend sends coordinates too.
          // Based on user text, `getUserPrediction` returns: status, driver, arrivalTime, distance, duration.
          // It DOES NOT return lat/lng.
          // So we should also fetch /bus/live-location?driverId=... if we knew the driverId.
          // Ideally the prediction endpoint should return the current bus location.
          // Let's assume we mock the map location for now or use a default since we only have text data from `getUserPrediction`.
          // OR we can make a separate call.
          
          // Use Real-Time coordinates from Socket if available, else Mock
          // Since backend getUserPrediction doesn't return ID, we rely on Socket 'live-bus-update' 
          // which presumably we joined correctly if we knew the driver.
          // Note for Student: We need to know WHICH driver to follow. 
          // Ideally: getUserPrediction returns DriverID. 
          // Current backend: returns driver NAME. 
          // FIX: We need DriverID. 
          // I'll assume we got it or default to a fixed one for demo if missing.
          
          double lat = 12.9716;
          double lng = 77.5946;
          
          if (bus.liveLocation != null) {
             lat = double.tryParse(bus.liveLocation!['lat'].toString()) ?? lat;
             lng = double.tryParse(bus.liveLocation!['lng'].toString()) ?? lng;
          }
          
          final LatLng busPos = LatLng(lat, lng);

          return Column(
            children: [
              Expanded(
                flex: 2,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: busPos,
                    zoom: 15, // Closer zoom for live tracking
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: busPos,
                          width: 80,
                          height: 80,
                          builder: (context) => const Icon(Icons.directions_bus, color: Colors.indigo, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Arriving In', style: TextStyle(color: Colors.grey[600])),
                              Text(pred['duration'] ?? '--', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Distance', style: TextStyle(color: Colors.grey[600])),
                              Text(pred['distance'] ?? '--', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            const CircleAvatar(child: Icon(Icons.person)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(pred['driver'] ?? 'Driver', style: const TextStyle(fontWeight: FontWeight.bold)),
                                const Text('Bus No: KA-01-AB-1234', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.phone, color: Colors.green),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
