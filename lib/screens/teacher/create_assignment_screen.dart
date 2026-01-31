import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/academic_provider.dart';
import '../../providers/auth_provider.dart';

class CreateAssignmentScreen extends StatefulWidget {
  const CreateAssignmentScreen({super.key});

  @override
  State<CreateAssignmentScreen> createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final _topicCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _semCtrl = TextEditingController(text: '1');

  void _post() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      try {
        await Provider.of<AcademicProvider>(context, listen: false).createAssignment({
          'teacherId': user.id,
          'topic': _topicCtrl.text,
          'description': _descCtrl.text,
          'submissionDate': _dateCtrl.text,
          'semester': _semCtrl.text
        });
        if(mounted) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assignment Created!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Assignment')),
      body: SingleChildScrollView(
         padding: const EdgeInsets.all(20),
         child: Column(
           children: [
             TextField(controller: _topicCtrl, decoration: const InputDecoration(labelText: 'Topic', border: OutlineInputBorder())),
             const SizedBox(height: 16),
             TextField(controller: _descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
             const SizedBox(height: 16),
             TextField(controller: _dateCtrl, decoration: const InputDecoration(labelText: 'Submission Date (YYYY-MM-DD)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today))),
             const SizedBox(height: 16),
             TextField(controller: _semCtrl, decoration: const InputDecoration(labelText: 'Semester', border: OutlineInputBorder())),
             const SizedBox(height: 32),
             SizedBox(
               width: double.infinity,
               height: 50,
               child: ElevatedButton(onPressed: _post, child: const Text('Post Assignment')),
             )
           ],
         ),
      ),
    );
  }
}
