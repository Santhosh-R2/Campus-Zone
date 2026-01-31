import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:animate_do/animate_do.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      Provider.of<AttendanceProvider>(context, listen: false).fetchHistory(user.id);
    }
  }

  void _mark(String status) async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      try {
        await Provider.of<AttendanceProvider>(context, listen: false)
          .markAttendance(user.id, status, lat: 12.9716, lng: 77.5946); // Mock Loc
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marked as $status')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _mark('present'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Check In (Present)'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _mark('absent'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Mark Absent'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("History", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          Expanded(
            child: Consumer<AttendanceProvider>(
              builder: (context, attendance, _) {
                 if (attendance.isLoading) return const Center(child: CircularProgressIndicator());
                 if (attendance.history.isEmpty) return const Center(child: Text('No records found.'));

                 return ListView.builder(
                   itemCount: attendance.history.length,
                   itemBuilder: (context, index) {
                     final rec = attendance.history[index];
                     return FadeInLeft(
                       delay: Duration(milliseconds: index * 50),
                       child: ListTile(
                         leading: Icon(
                           rec['status'] == 'present' ? Icons.check_circle : Icons.cancel,
                           color: rec['status'] == 'present' ? Colors.green : Colors.red,
                         ),
                         title: Text(rec['date'] ?? ''),
                         subtitle: Text(rec['status']?.toUpperCase() ?? ''),
                       ),
                     );
                   },
                 );
              },
            ),
          )
        ],
      ),
    );
  }
}
