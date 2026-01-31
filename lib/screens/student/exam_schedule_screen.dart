import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/academic_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:animate_do/animate_do.dart';

class ExamScheduleScreen extends StatefulWidget {
  const ExamScheduleScreen({super.key});

  @override
  State<ExamScheduleScreen> createState() => _ExamScheduleScreenState();
}

class _ExamScheduleScreenState extends State<ExamScheduleScreen> {
  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      Provider.of<AcademicProvider>(context, listen: false)
        .fetchExamSchedule(studentId: user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Schedule')),
      body: Consumer<AcademicProvider>(
        builder: (context, academic, _) {
          if (academic.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (academic.exams.isEmpty) {
            return Center(
              child: FadeInUp(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text('No exams scheduled yet'),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: academic.exams.length,
            itemBuilder: (context, index) {
              final exam = academic.exams[index];
              return FadeInUp(
                delay: Duration(milliseconds: index * 100),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.event_note, color: Colors.blue),
                    ),
                    title: Text(exam['subject'] ?? 'Unknown Subject', 
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${exam['date']} • ${exam['time']}'),
                    trailing: Text(exam['room'] ?? '', 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
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
