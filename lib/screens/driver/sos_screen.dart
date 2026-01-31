import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bus_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:animate_do/animate_do.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  void _trigger() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
       // Mock Location
       await Provider.of<BusProvider>(context, listen: false)
         .triggerSOS(user.id, "EMERGENCY: Driver Reported Issue", 12.9716, 77.5946);
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SOS SENT! ADMIN NOTIFIED.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50], // Warning feel
      appBar: AppBar(title: const Text('EMERGENCY SOS', style: TextStyle(color: Colors.red))),
      body: Center(
        child: FadeIn(
          duration: const Duration(milliseconds: 500),
          child: Pulse(
            infinite: true,
            child: GestureDetector(
              onLongPress: _trigger, // Long press to avoid accidental
              child: Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.redAccent, blurRadius: 40, spreadRadius: 10)],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 80, color: Colors.white),
                    Text('HOLD TO\nSEND SOS', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
