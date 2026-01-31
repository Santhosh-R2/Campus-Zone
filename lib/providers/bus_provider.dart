import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BusProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  bool _isLoading = false;
  
  // Data
  Map<String, dynamic>? _prediction;
  Map<String, dynamic>? _liveLocation;
  List<dynamic> _passengers = [];
  List<dynamic> _comingUsers = [];
  List<dynamic> _routeStops = [];

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get prediction => _prediction;
  Map<String, dynamic>? get liveLocation => _liveLocation;
  List<dynamic> get passengers => _passengers;
  List<dynamic> get comingUsers => _comingUsers;
  List<dynamic> get routeStops => _routeStops;

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

  // STUDENT: Get Prediction and Live Location
  Future<void> fetchPrediction(String userId) async {
    // We don't use _performAction simply to avoid full UI blocking on refresh
    try {
      final predRes = await _api.get('/bus/prediction/$userId');
      _prediction = predRes;
      
      // If we have an active driver, fetch their live location for the map
      if (_prediction != null && _prediction!['driver'] != null) {
         // Note: Prediction returns driver NAME, not ID. 
         // But getUserPrediction endpoint logic implies we might need to find driverId differently 
         // or we assume the frontend knows the driverId via other means or backend returns it.
         // Looking at user code: `activeTrip.populate('driverId', 'name')` -> sends `driverId.name`.
         // It does NOT send driverId. This is a potential backend gap.
         // However, `getLiveLocation` requires `driverId`.
         // I will assume for now we cannot fetch live coordinates without driverId.
         // I'll check if I can get driverId from somewhere else or add it to backend response if I could (I can't edit backend easily).
         // Actually, `getUserPrediction` in backend:
         // `driver: activeTrip.driverId.name`
         // It doesn't send the ID. 
         // Workaround: Use `_prediction` data for text, and maybe we can't show map unless we guess driverId?
         // Wait, the Student Dashboard doesn't save driverId.
         
         // Let's assume I can adjust `getUserPrediction` in my head or just try to get it.
         // Actually, let's fix the backend code if I could? No, user gave it.
         // I will ignore getLiveLocation for prediction unless I have driverId.
      }
      notifyListeners();
    } catch (e) {
      _prediction = null;
      notifyListeners();
    }
  }

  // PUBLIC: Get Live Location (If we know Driver ID)
  Future<void> fetchLiveLocation(String driverId) async {
    try {
       final res = await _api.get('/bus/live-location', queryParameters: {'driverId': driverId});
       _liveLocation = res['data']; // { lat, lng, speed ... }
       notifyListeners();
    } catch (e) {
      _liveLocation = null;
    }
  }

  // STUDENT: Set Daily Status (Coming/Absent)
  Future<void> setDailyStatus(String userId, String status, {String? driverId}) async {
    await _performAction(() async {
      await _api.post('/bus/status', {
        'userId': userId,
        'status': status,
        'driverId': driverId
      });
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
  
  // DRIVER: Get Route
  Future<void> fetchRoute(String driverId) async {
    await _performAction(() async {
      final res = await _api.get('/bus/route', queryParameters: {'driverId': driverId});
      // Backend returns: { start, stops: [], end, ... }
      if (res != null && res['stops'] != null) {
        _routeStops = res['stops'];
      }
    });
  }

  // DRIVER: Get Coming Users
  Future<void> fetchComingUsers(String driverId) async {
    await _performAction(() async {
       final res = await _api.get('/bus/coming-users', queryParameters: {'driverId': driverId});
       if (res != null && res['users'] != null) {
         _comingUsers = res['users'];
       }
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
