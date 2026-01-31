import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/academic_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:animate_do/animate_do.dart';

class MarksScreen extends StatefulWidget {
  const MarksScreen({super.key});

  @override
  State<MarksScreen> createState() => _MarksScreenState();
}

class _MarksScreenState extends State<MarksScreen> {
  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      Provider.of<AcademicProvider>(context, listen: false)
        .fetchMyMarks(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Results')),
      body: Consumer<AcademicProvider>(
        builder: (context, academic, _) {
          if (academic.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (academic.marks.isEmpty) {
            return const Center(child: Text('No marks published yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: academic.marks.length,
            itemBuilder: (context, index) {
              final result = academic.marks[index];
              return FadeInUp(
                delay: Duration(milliseconds: index * 100),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircularProgressIndicator(
                      value: (result['marksObtained'] ?? 0) / (result['totalMarks'] ?? 100),
                      backgroundColor: Colors.grey[200],
                      color: (result['marksObtained'] ?? 0) < 40 ? Colors.red : Colors.green,
                    ),
                    title: Text(result['subject'] ?? 'Subject', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(result['examType'] ?? 'Exam'),
                    trailing: Text(
                      '${result['marksObtained']} / ${result['totalMarks']}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
