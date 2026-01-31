import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'exam_schedule_screen.dart';
import 'marks_screen.dart';
import 'assignments_screen.dart';
import 'bus_tracking_screen.dart';
import '../home/attendance_screen.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

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
          if (title == 'Arrival Prediction') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const BusTrackingScreen()));
          }
        },
      ),
    );
  }
}
