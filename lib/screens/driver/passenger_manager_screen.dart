import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bus_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class PassengerManagerScreen extends StatefulWidget {
  const PassengerManagerScreen({super.key});

  @override
  State<PassengerManagerScreen> createState() => _PassengerManagerScreenState();
}

class _PassengerManagerScreenState extends State<PassengerManagerScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
     super.initState();
     _loadMyPassengers();
  }

  void _loadMyPassengers() {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      Provider.of<BusProvider>(context, listen: false).fetchMyPassengers(user.id);
    }
  }

  void _search() async {
    // In a real app we would call an API to search, but here we fetch all and filter client side or assume limited list
    // The previous code had `getAllUsers`.
    setState(() => _isSearching = true);
    try {
      final res = await ApiService().get('/bus/all-users');
      // Simple client side filter
      if (res is List) {
        setState(() {
          _searchResults = res.where((u) => 
            u['name'].toString().toLowerCase().contains(_searchCtrl.text.toLowerCase())
          ).toList();
        });
      }
    } catch(e) {
      // Error
    } finally {
      setState(() => _isSearching = false);
    }
  }

  void _add(String userId) async {
    final driver = Provider.of<AuthProvider>(context, listen: false).user;
    if (driver != null) {
      await Provider.of<BusProvider>(context, listen: false).addPassenger(driver.id, userId);
    }
  }

  void _remove(String userId) async {
    final driver = Provider.of<AuthProvider>(context, listen: false).user;
    if (driver != null) {
      await Provider.of<BusProvider>(context, listen: false).removePassenger(driver.id, userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Passengers'),
          bottom: const TabBar(tabs: [Tab(text: 'My List'), Tab(text: 'Add New')]),
        ),
        body: TabBarView(
          children: [
            // Tab 1: My Passengers
            Consumer<BusProvider>(
              builder: (context, bus, _) {
                 if (bus.isLoading) return const Center(child: CircularProgressIndicator());
                 if (bus.passengers.isEmpty) return const Center(child: Text('No passengers assigned.'));
                 
                 return ListView.builder(
                   itemCount: bus.passengers.length,
                   itemBuilder: (context, index) {
                     final p = bus.passengers[index];
                     return ListTile(
                       title: Text(p['name'] ?? ''),
                       subtitle: Text(p['email'] ?? ''),
                       trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _remove(p['_id'])),
                     );
                   },
                 );
              },
            ),
            
            // Tab 2: Search & Add
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(child: TextField(controller: _searchCtrl, decoration: const InputDecoration(hintText: 'Search Name'))),
                      IconButton(icon: const Icon(Icons.search), onPressed: _search)
                    ],
                  ),
                ),
                Expanded(
                  child: _isSearching 
                   ? const Center(child: CircularProgressIndicator())
                   : ListView.builder(
                     itemCount: _searchResults.length,
                     itemBuilder: (context, index) {
                        final u = _searchResults[index];
                        return ListTile(
                          title: Text(u['name']),
                          subtitle: Text(u['role']),
                          trailing: IconButton(icon: const Icon(Icons.add, color: Colors.green), onPressed: () => _add(u['_id'])),
                        );
                     },
                   ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
