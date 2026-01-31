import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../student/student_dashboard.dart';
import '../teacher/teacher_dashboard.dart';
import '../driver/driver_dashboard.dart';
import '../non_faculty/non_faculty_dashboard.dart';

class HomeRouter extends StatelessWidget {
  const HomeRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (user.role) {
      case 'student':
        return const StudentDashboard();
      case 'teacher':
        return const TeacherDashboard();
      case 'driver':
        return const DriverDashboard();
      case 'non-faculty':
        return const NonFacultyDashboard();
      default:
        return Scaffold(
          body: Center(child: Text('Unknown Role: ${user.role}')),
        );
    }
  }
}
