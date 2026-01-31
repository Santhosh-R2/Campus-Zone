import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import 'package:animate_do/animate_do.dart';

class LiveClassAttendanceScreen extends StatefulWidget {
  const LiveClassAttendanceScreen({super.key});

  @override
  State<LiveClassAttendanceScreen> createState() => _LiveClassAttendanceScreenState();
}

class _LiveClassAttendanceScreenState extends State<LiveClassAttendanceScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _fetchLiveAttendance();
  }

  void _fetchLiveAttendance() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      try {
        final res = await ApiService().get('/attendance/live-class', queryParameters: {'teacherId': user.id});
        setState(() {
          _data = res;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        // Error handling
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Class Status')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _data == null 
          ? const Center(child: Text('Failed to load data'))
          : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Stats Card
                FadeInDown(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade800]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Total', '${_data!['totalStudents']}'),
                        Container(width: 1, height: 40, color: Colors.white54),
                        _buildStat('Present', '${_data!['presentCount']}'),
                        Container(width: 1, height: 40, color: Colors.white54),
                        _buildStat('Absent', '${_data!['totalStudents'] - _data!['presentCount']}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft, 
                  child: Text('Student List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: (_data!['students'] as List).length,
                    itemBuilder: (context, index) {
                      final student = _data!['students'][index];
                      final isPresent = student['status'] == 'present';
                      return FadeInUp(
                        delay: Duration(milliseconds: index * 50),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isPresent ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                              child: Icon(isPresent ? Icons.check : Icons.close, color: isPresent ? Colors.green : Colors.red),
                            ),
                            title: Text(student['name']),
                            subtitle: Text(student['email']),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isPresent ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Text(student['status'].toString().toUpperCase(), 
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
