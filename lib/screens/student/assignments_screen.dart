import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/academic_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:animate_do/animate_do.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null && user.classTeacherId != null) {
      Provider.of<AcademicProvider>(context, listen: false)
        .fetchAssignments(user.classTeacherId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: Consumer<AcademicProvider>(
        builder: (context, academic, _) {
          if (academic.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (academic.assignments.isEmpty) {
            return const Center(child: Text('No assignments pending.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: academic.assignments.length,
            itemBuilder: (context, index) {
              final assign = academic.assignments[index];
              return FadeInUp(
                delay: Duration(milliseconds: index * 100),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(assign['topic'] ?? 'No Topic', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Chip(
                              label: Text('Due: ${assign['submissionDate']}'),
                              backgroundColor: Colors.red[50],
                              labelStyle: const TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(assign['description'] ?? '', style: TextStyle(color: Colors.grey[700])),
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
