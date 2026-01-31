import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BusProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  bool _isLoading = false;
  
  // Data
  Map<String, dynamic>? _prediction;
  List<dynamic> _passengers = [];
  List<dynamic> _comingUsers = [];

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get prediction => _prediction;
  List<dynamic> get passengers => _passengers;
  List<dynamic> get comingUsers => _comingUsers;

  Future<void> _performAction(Future<void> Function() action) async {
    _isLoading = true;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // STUDENT: Get Prediction
  Future<void> fetchPrediction(String userId) async {
    await _performAction(() async {
      try {
        final res = await _api.get('/bus/prediction/$userId');
        _prediction = res;
      } catch (e) {
        _prediction = null; // No active trip
      }
    });
  }

  // DRIVER: Start Trip
  Future<void> startTrip(String driverId, double lat, double lng) async {
    await _performAction(() async {
      await _api.post('/bus/start-trip', {
        'driverId': driverId,
        'lat': lat,
        'lng': lng
      });
    });
  }

  // DRIVER: End Trip
  Future<void> endTrip(String driverId) async {
     await _performAction(() async {
      await _api.post('/bus/end-trip', {'driverId': driverId});
    });
  }

  // DRIVER: Trigger SOS
  Future<void> triggerSOS(String driverId, String reason, double lat, double lng) async {
     await _performAction(() async {
      await _api.post('/bus/sos', {
        'driverId': driverId,
        'reason': reason,
        'lat': lat,
        'lng': lng
      });
    });
  }

  // DRIVER: Get My Passengers
  Future<void> fetchMyPassengers(String driverId) async {
    await _performAction(() async {
      final res = await _api.get('/bus/my-passengers', queryParameters: {'driverId': driverId});
      _passengers = res is List ? res : [];
    });
  }

  // DRIVER: Add Passenger
  Future<void> addPassenger(String driverId, String passengerId) async {
    await _performAction(() async {
      await _api.post('/bus/add-passenger', {'driverId': driverId, 'passengerId': passengerId});
      await fetchMyPassengers(driverId); // Refresh
    });
  }

  // DRIVER: Remove Passenger
  Future<void> removePassenger(String driverId, String passengerId) async {
    await _performAction(() async {
      await _api.post('/bus/remove-passenger', {'driverId': driverId, 'passengerId': passengerId});
      await fetchMyPassengers(driverId);
    });
  }
}
