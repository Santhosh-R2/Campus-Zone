import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'student';
  String? _selectedTeacherId;
  List<dynamic> _teachers = [];

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
  }

  void _fetchTeachers() async {
    try {
      final data = await ApiService().get('/teachers');
      setState(() {
        _teachers = data;
      });
    } catch (e) {
      // Handle error
    }
  }

  void _handleRegister() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'role': _selectedRole,
      'lat': 0, // Placeholder
      'lng': 0, // Placeholder
    };

    if (_selectedRole == 'student' && _selectedTeacherId != null) {
      userData['classTeacherId'] = _selectedTeacherId!;
    }

    try {
      await auth.register(userData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful! Please wait for approval.'))
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeInUp(
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: ['student', 'teacher', 'driver', 'non-faculty']
                      .map((role) => DropdownMenuItem(value: role, child: Text(role.toUpperCase())))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedRole = val!),
                ),
              ),
              if (_selectedRole == 'student') ...[
                const SizedBox(height: 16),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: DropdownButtonFormField<String>(
                    value: _selectedTeacherId,
                    decoration: const InputDecoration(labelText: 'Select Class Teacher'),
                    items: _teachers
                        .map((t) => DropdownMenuItem(value: t['_id'] as String, child: Text(t['name'] as String)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedTeacherId = val),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return ElevatedButton(
                      onPressed: auth.isLoading ? null : _handleRegister,
                      child: auth.isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Register'),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
