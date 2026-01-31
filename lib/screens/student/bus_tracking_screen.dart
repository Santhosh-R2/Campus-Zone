import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bus_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:animate_do/animate_do.dart';

class BusTrackingScreen extends StatefulWidget {
  const BusTrackingScreen({super.key});

  @override
  State<BusTrackingScreen> createState() => _BusTrackingScreenState();
}

class _BusTrackingScreenState extends State<BusTrackingScreen> {
  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      Provider.of<BusProvider>(context, listen: false).fetchPrediction(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Bus Status')),
      body: Consumer<BusProvider>(
        builder: (context, bus, _) {
          if (bus.isLoading) return const Center(child: CircularProgressIndicator());
          
          final pred = bus.prediction;

          if (pred == null || pred['status'] != 'ACTIVE') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bus_alert_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('No Active Trip Found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text('The bus has not started yet.'),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                FadeInDown(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Column(
                      children: [
                        const Text('Expected Arrival', style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 8),
                        Text(
                          pred['predictedArrivalTime'] ?? '--:--',
                          style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat('Distance', pred['distance'] ?? '0 m'),
                            _buildStat('Duration', pred['duration'] ?? '0 min'),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  child: Text('Driver: ${pred['driver']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                     final user = Provider.of<AuthProvider>(context, listen: false).user;
                     if (user != null) bus.fetchPrediction(user.id);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Status'),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
