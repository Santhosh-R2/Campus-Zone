import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/academic_provider.dart';
import '../../providers/auth_provider.dart';

class AddMarksScreen extends StatefulWidget {
  const AddMarksScreen({super.key});

  @override
  State<AddMarksScreen> createState() => _AddMarksScreenState();
}

class _AddMarksScreenState extends State<AddMarksScreen> {
  final _semesterCtrl = TextEditingController(text: '1');
  final _subjectCtrl = TextEditingController();
  final _marksCtrl = TextEditingController();
  final _totalCtrl = TextEditingController(text: '100');
  final _examTypeCtrl = TextEditingController(text: 'Final');

  String? _selectedStudentId;
  
  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      Provider.of<AcademicProvider>(context, listen: false).fetchMyClass(user.id);
    }
  }

  void _submit() async {
    if (_selectedStudentId == null) return;
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
       try {
         await Provider.of<AcademicProvider>(context, listen: false).addMarks({
           'teacherId': user.id,
           'studentId': _selectedStudentId,
           'semester': _semesterCtrl.text,
           'subject': _subjectCtrl.text,
           'marks': int.tryParse(_marksCtrl.text) ?? 0,
           'total': int.tryParse(_totalCtrl.text) ?? 100,
           'examType': _examTypeCtrl.text
         });
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marks Added!')));
         _marksCtrl.clear();
         _subjectCtrl.clear();
       } catch (e) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Marks')),
      body: Consumer<AcademicProvider>(
        builder: (context, academic, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedStudentId,
                  hint: const Text('Select Student'),
                  items: academic.myStudents.map<DropdownMenuItem<String>>((s) {
                    return DropdownMenuItem(value: s['_id'], child: Text(s['name']));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedStudentId = val),
                ),
                const SizedBox(height: 16),
                TextField(controller: _semesterCtrl, decoration: const InputDecoration(labelText: 'Semester')),
                const SizedBox(height: 16),
                TextField(controller: _examTypeCtrl, decoration: const InputDecoration(labelText: 'Exam Type (e.g. Midterm)')),
                const SizedBox(height: 16),
                TextField(controller: _subjectCtrl, decoration: const InputDecoration(labelText: 'Subject')),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: TextField(controller: _marksCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Marks Obtained'))),
                    const SizedBox(width: 16),
                    Expanded(child: TextField(controller: _totalCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Marks'))),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(onPressed: _submit, child: const Text('Save Result')),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
