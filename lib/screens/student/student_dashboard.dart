import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'exam_schedule_screen.dart';
import 'marks_screen.dart';
import 'assignments_screen.dart';
import 'bus_tracking_screen.dart';
import '../../providers/bus_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../home/attendance_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  void initState() {
    super.initState();
    // Initialize Socket Connection for Real-Time Updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      // We ideally need the driverID here to join the room 'trip-driverId'.
      // If we don't have it, we might listen to 'class-teacherId' or global.
      // For now, we will connect as 'student'.
      if (user != null) {
         Provider.of<BusProvider>(context, listen: false).initSocket('student', classTeacherId: user.classTeacherId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Hub', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInLeft(
              child: const Text('Academic Tools', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildCard(context, 'Exam Schedule', FontAwesomeIcons.calendarDay, Colors.blue),
                _buildCard(context, 'My marks', FontAwesomeIcons.fileLines, Colors.orange),
                _buildCard(context, 'Assignments', FontAwesomeIcons.book, Colors.purple),
                _buildCard(context, 'Attendance', FontAwesomeIcons.userCheck, Colors.green),
              ],
            ),
            const SizedBox(height: 32),
            FadeInLeft(
              child: const Text('Transport', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            _buildActionTile(context, 'Live Bus Location', Icons.bus_alert, Colors.redAccent),
            const SizedBox(height: 12),
            _buildActionTile(context, 'Set Bus Status', Icons.directions_bus_filled_outlined, Colors.orange),
            const SizedBox(height: 12),
            _buildActionTile(context, 'Arrival Prediction', Icons.timer_outlined, Colors.indigo),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Color color) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () {
          if (title == 'Exam Schedule') Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamScheduleScreen()));
          if (title == 'My marks') Navigator.push(context, MaterialPageRoute(builder: (_) => const MarksScreen()));
          if (title == 'Assignments') Navigator.push(context, MaterialPageRoute(builder: (_) => const AssignmentsScreen()));
          if (title == 'Attendance') Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen()));
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 12),
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, String title, IconData icon, Color color) {
    return FadeInUp(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (title == 'Arrival Prediction' || title == 'Live Bus Location') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const BusTrackingScreen()));
          }
          if (title == 'Set Bus Status') {
            _showBusStatusDialog(context);
          }
        },
      ),
    );
  }

  void _showBusStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Today\'s Bus Status'),
        content: const Text('Are you coming to college by bus today?'),
        actions: [
          TextButton(
            onPressed: () {
              // Absent
              final user = Provider.of<AuthProvider>(context, listen: false).user;
              if (user != null) {
                Provider.of<BusProvider>(context, listen: false).setDailyStatus(user.id, 'absent');
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marked as Absent')));
            }, 
            child: const Text('No (Absent)', style: TextStyle(color: Colors.red))
          ),
          ElevatedButton(
            onPressed: () {
              // Coming
              final user = Provider.of<AuthProvider>(context, listen: false).user;
              if (user != null) {
                Provider.of<BusProvider>(context, listen: false).setDailyStatus(user.id, 'coming');
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marked as Coming')));
            }, 
            child: const Text('Yes (Coming)')
          ),
        ],
      )
    );
  }
}
