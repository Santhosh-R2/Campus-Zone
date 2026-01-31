import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bus_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:animate_do/animate_do.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  // Mock Location (In real app, use Geolocator)
  final double _mockLat = 12.9716; 
  final double _mockLng = 77.5946;

  void _toggleTrip(bool start) async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      try {
        if (start) {
          await Provider.of<BusProvider>(context, listen: false).startTrip(user.id, _mockLat, _mockLng);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip Started!')));
        } else {
           await Provider.of<BusProvider>(context, listen: false).endTrip(user.id);
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip Ended!')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip Control')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              child: GestureDetector(
                onTap: () => _toggleTrip(true),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 20, spreadRadius: 5)],
                  ),
                  child: const Center(
                    child: Text('START\nTRIP', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            FadeInUp(
              child: GestureDetector(
                onTap: () => _toggleTrip(false),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 20, spreadRadius: 5)],
                  ),
                  child: const Center(
                    child: Text('END\nTRIP', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
