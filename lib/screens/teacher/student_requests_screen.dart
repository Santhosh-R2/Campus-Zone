import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/academic_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:animate_do/animate_do.dart';

class StudentRequestsScreen extends StatefulWidget {
  const StudentRequestsScreen({super.key});

  @override
  State<StudentRequestsScreen> createState() => _StudentRequestsScreenState();
}

class _StudentRequestsScreenState extends State<StudentRequestsScreen> {
  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      Provider.of<AcademicProvider>(context, listen: false).fetchStudentRequests(user.id);
    }
  }

  void _handleAction(String studentId, String status) async {
    try {
      await Provider.of<AcademicProvider>(context, listen: false)
          .handleRequest(studentId, status);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request $status')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admission Requests')),
      body: Consumer<AcademicProvider>(
        builder: (context, academic, _) {
          if (academic.isLoading) return const Center(child: CircularProgressIndicator());
          
          if (academic.studentRequests.isEmpty) {
             return const Center(child: Text('No pending requests'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: academic.studentRequests.length,
            itemBuilder: (context, index) {
              final student = academic.studentRequests[index];
              return FadeInUp(
                child: Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(student['name'] ?? 'Unknown'),
                    subtitle: Text(student['email'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => _handleAction(student['_id'], 'accepted'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _handleAction(student['_id'], 'rejected'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
