import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/bus_provider.dart';
import 'package:animate_do/animate_do.dart';

class ComingUsersScreen extends StatefulWidget {
  const ComingUsersScreen({super.key});

  @override
  State<ComingUsersScreen> createState() => _ComingUsersScreenState();
}

class _ComingUsersScreenState extends State<ComingUsersScreen> {
  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      Provider.of<BusProvider>(context, listen: false).fetchComingUsers(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Who is Coming?')),
      body: Consumer<BusProvider>(
        builder: (context, bus, _) {
          if (bus.isLoading) return const Center(child: CircularProgressIndicator());
          
          if (bus.comingUsers.isEmpty) {
            return const Center(child: Text('No passengers marked "Coming" today.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bus.comingUsers.length,
            itemBuilder: (context, index) {
              final student = bus.comingUsers[index];
              return FadeInUp(
                delay: Duration(milliseconds: index * 50),
                child: Card(
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.check, color: Colors.white)),
                    title: Text(student['name'] ?? 'Unknown'),
                    subtitle: Text(student['email'] ?? ''),
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
