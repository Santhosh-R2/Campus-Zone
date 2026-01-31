import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/academic_provider.dart';
import '../../providers/auth_provider.dart';

class CreateExamScheduleScreen extends StatefulWidget {
  const CreateExamScheduleScreen({super.key});

  @override
  State<CreateExamScheduleScreen> createState() => _CreateExamScheduleScreenState();
}

class _CreateExamScheduleScreenState extends State<CreateExamScheduleScreen> {
  final List<Map<String, String>> _exams = [];
  final _subjectCtrl = TextEditingController();
  final _dateCtrl = TextEditingController(); // YYYY-MM-DD
  final _timeCtrl = TextEditingController();
  final _roomCtrl = TextEditingController();
  final _semesterCtrl = TextEditingController(text: '1');

  void _addExam() {
    if (_subjectCtrl.text.isNotEmpty) {
      setState(() {
        _exams.add({
          'subject': _subjectCtrl.text,
          'date': _dateCtrl.text,
          'time': _timeCtrl.text,
          'room': _roomCtrl.text,
        });
        _subjectCtrl.clear();
        _dateCtrl.clear();
        _timeCtrl.clear();
        _roomCtrl.clear();
      });
    }
  }

  void _publish() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      try {
        await Provider.of<AcademicProvider>(context, listen: false).createExamSchedule({
          'teacherId': user.id,
          'semester': _semesterCtrl.text,
          'exams': _exams
        });
        if(mounted) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Schedule Published!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Schedule')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
             TextField(controller: _semesterCtrl, decoration: const InputDecoration(labelText: 'Semester', border: OutlineInputBorder())),
             const SizedBox(height: 16),
             const Divider(),
             const Text('Add Exam Entry', style: TextStyle(fontWeight: FontWeight.bold)),
             const SizedBox(height: 8),
             TextField(controller: _subjectCtrl, decoration: const InputDecoration(hintText: 'Subject')),
             Row(
               children: [
                 Expanded(child: TextField(controller: _dateCtrl, decoration: const InputDecoration(hintText: 'YYYY-MM-DD'))),
                 const SizedBox(width: 8),
                 Expanded(child: TextField(controller: _timeCtrl, decoration: const InputDecoration(hintText: 'Time (e.g. 10:00 AM)'))),
               ],
             ),
             TextField(controller: _roomCtrl, decoration: const InputDecoration(hintText: 'Room No')),
             const SizedBox(height: 8),
             ElevatedButton(onPressed: _addExam, child: const Text('Add to List')),
             
             const SizedBox(height: 24),
             if (_exams.isNotEmpty) ...[
               const Text('Preview:', style: TextStyle(fontWeight: FontWeight.bold)),
               ..._exams.map((e) => ListTile(
                 title: Text(e['subject']!),
                 subtitle: Text('${e['date']} @ ${e['time']}'),
                 trailing: IconButton(
                   icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => _exams.remove(e));
                    },
                 ),
               )),
               const SizedBox(height: 16),
               SizedBox(
                 width: double.infinity,
                 height: 50,
                 child: ElevatedButton(
                   onPressed: _publish,
                   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                   child: const Text('Publish Schedule'),
                 ),
               )
             ]
          ],
        ),
      ),
    );
  }
}
