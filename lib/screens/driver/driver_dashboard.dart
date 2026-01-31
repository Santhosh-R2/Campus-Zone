import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'trip_screen.dart';
import 'passenger_manager_screen.dart';
import 'route_screen.dart';
import 'sos_screen.dart';
import 'coming_users_screen.dart';

class DriverDashboard extends StatelessWidget {
  const DriverDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fleet Command', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            FadeInDown(
                    children: [
                  _buildControlCard(context, 'Trip Control', Icons.bus_alert, Colors.white, isStart: true),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildControlCard(context, 'My Passengers', Icons.people_outline, Colors.blue),
                  _buildControlCard(context, 'Optimize Route', Icons.directions_rounded, Colors.green),
                  _buildControlCard(context, 'Coming List', Icons.how_to_reg_rounded, Colors.orange), // Now 'Coming List'
                  _buildControlCard(context, 'Emergency SOS', Icons.warning_amber_rounded, Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlCard(BuildContext context, String title, IconData icon, Color color, {bool isStart = false}) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () {
          if (isStart) Navigator.push(context, MaterialPageRoute(builder: (_) => const TripScreen()));
          if (title == 'My Passengers') Navigator.push(context, MaterialPageRoute(builder: (_) => const PassengerManagerScreen()));
          if (title == 'Optimize Route') Navigator.push(context, MaterialPageRoute(builder: (_) => const RouteScreen()));
          if (title == 'Coming List') Navigator.push(context, MaterialPageRoute(builder: (_) => const ComingUsersScreen()));
          if (title == 'Emergency SOS') Navigator.push(context, MaterialPageRoute(builder: (_) => const SOSScreen()));
        },
        child: Container(
          decoration: BoxDecoration(
            color: isStart ? Colors.indigo : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
