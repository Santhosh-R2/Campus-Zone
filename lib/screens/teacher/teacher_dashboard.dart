import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'student_requests_screen.dart';
import 'broadcast_screen.dart';
import 'my_class_list_screen.dart';
import 'create_exam_schedule_screen.dart';
import 'add_marks_screen.dart';
import 'create_assignment_screen.dart';
import 'live_class_attendance_screen.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDashboardItem(context, 'Student Requests', Icons.person_add_alt_1, 'Manage admission requests', Colors.blue),
            const SizedBox(height: 16),
            _buildDashboardItem(context, 'Class Broadcast', Icons.campaign_rounded, 'Notify all students', Colors.orange),
            const SizedBox(height: 16),
            _buildDashboardItem(context, 'My Class List', Icons.groups_rounded, 'View assigned students', Colors.green),
            const SizedBox(height: 16),
            _buildDashboardItem(context, 'Post Exam Schedule', Icons.grid_view_rounded, 'Plan semester exams', Colors.purple),
            const SizedBox(height: 16),
            _buildDashboardItem(context, 'Add Student Marks', Icons.add_chart_rounded, 'Upload academic results', Colors.indigo),
            const SizedBox(height: 16),
            _buildDashboardItem(context, 'Create Assignment', Icons.note_add_rounded, 'Post new class tasks', Colors.pink),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context, String title, IconData icon, String subtitle, Color color) {
    return FadeInRight(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.grey.shade200)),
        child: ListTile(
          onTap: () {
            if (title == 'Student Requests') Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentRequestsScreen()));
            if (title == 'Class Broadcast') Navigator.push(context, MaterialPageRoute(builder: (_) => const BroadcastScreen()));
            if (title == 'My Class List') Navigator.push(context, MaterialPageRoute(builder: (_) => const MyClassListScreen()));
            if (title == 'Live Attendance') Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveClassAttendanceScreen()));
            if (title == 'Post Exam Schedule') Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateExamScheduleScreen()));
            if (title == 'Add Student Marks') Navigator.push(context, MaterialPageRoute(builder: (_) => const AddMarksScreen()));
            if (title == 'Create Assignment') Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAssignmentScreen()));
          },
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}
