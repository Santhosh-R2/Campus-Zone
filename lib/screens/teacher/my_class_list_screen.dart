import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/academic_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:animate_do/animate_do.dart';

class MyClassListScreen extends StatefulWidget {
  const MyClassListScreen({super.key});

  @override
  State<MyClassListScreen> createState() => _MyClassListScreenState();
}

class _MyClassListScreenState extends State<MyClassListScreen> {
  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      Provider.of<AcademicProvider>(context, listen: false).fetchMyClass(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Students')),
      body: Consumer<AcademicProvider>(
        builder: (context, academic, _) {
           if (academic.isLoading) return const Center(child: CircularProgressIndicator());
           
           if (academic.myStudents.isEmpty) return const Center(child: Text('No students assigned yet.'));

           return ListView.builder(
            itemCount: academic.myStudents.length,
            itemBuilder: (context, index) {
              final s = academic.myStudents[index];
              return FadeInUp(
                delay: Duration(milliseconds: index * 50),
                child: ListTile(
                  leading: CircleAvatar(child: Text(s['name']?[0] ?? '?')),
                  title: Text(s['name'] ?? 'Unknown'),
                  subtitle: Text(s['email'] ?? ''),
                ),
              );
            },
           );
        },
      ),
    );
  }
}
