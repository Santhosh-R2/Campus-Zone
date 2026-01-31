import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// Note: In a real app we would use the 'latlong2' and 'flutter_map' packages properly
// For this demo, we will show a list of stops.

class _RouteScreenState extends State<RouteScreen> {
  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      Provider.of<BusProvider>(context, listen: false).fetchRoute(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Today\'s Route')),
      body: Consumer<BusProvider>(
        builder: (context, bus, _) {
          if (bus.isLoading) return const Center(child: CircularProgressIndicator());
          if (bus.routeStops.isEmpty) return const Center(child: Text('No route required (0 coming).'));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bus.routeStops.length + 2, // Start + Stops + End
            itemBuilder: (context, index) {
              // Start Node
              if (index == 0) {
                return const ListTile(
                  leading: Icon(Icons.my_location, color: Colors.green),
                  title: Text('Start: Institute', style: TextStyle(fontWeight: FontWeight.bold)),
                );
              }
              // End Node
              if (index == bus.routeStops.length + 1) {
                 return const ListTile(
                  leading: Icon(Icons.flag, color: Colors.red),
                  title: Text('End: Institute', style: TextStyle(fontWeight: FontWeight.bold)),
                );
              }

              // Stops
              final stop = bus.routeStops[index - 1];
              return ListTile(
                leading: const Icon(Icons.location_on, color: Colors.orange),
                title: Text('Stop ${index}: ${stop['name']}'),
                subtitle: Text('Lat: ${stop['lat']}, Lng: ${stop['lng']}'),
              );
            },
          );
        },
      ),
    );
  }
}
