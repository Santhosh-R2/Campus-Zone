import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../home/attendance_screen.dart';
import '../student/bus_tracking_screen.dart';

class NonFacultyDashboard extends StatelessWidget {
  const NonFacultyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Portal', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInLeft(
              child: const Text('Quick Actions', 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
            _buildStaffTile(context, 'Mark Attendance', Icons.fingerprint, Colors.teal),
            const SizedBox(height: 16),
            _buildStaffTile(context, 'Attendance History', Icons.history_rounded, Colors.blueGrey),
            const SizedBox(height: 16),
            _buildStaffTile(context, 'Live Bus tracking', Icons.location_on_outlined, Colors.redAccent),
            const SizedBox(height: 16),
            _buildStaffTile(context, 'Arrival prediction', Icons.access_time_rounded, Colors.indigo),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffTile(BuildContext context, String title, IconData icon, Color color) {
    return FadeInRight(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        tileColor: color.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: color.withOpacity(0.1))),
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          if (title == 'Mark Attendance' || title == 'Attendance History') {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen()));
          }
           if (title == 'Arrival prediction' || title == 'Live Bus tracking') {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const BusTrackingScreen()));
          }
        },
      ),
    );
  }
}
