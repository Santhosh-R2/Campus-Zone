import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AttendanceProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  bool _isLoading = false;
  List<dynamic> _history = [];

  bool get isLoading => _isLoading;
  List<dynamic> get history => _history;

  Future<void> markAttendance(String userId, String status, {double lat = 0, double lng = 0}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _api.post('/attendance/mark', {
        'userId': userId,
        'status': status,
        'location': {'lat': lat, 'lng': lng}
      });
      // Refresh history
      await fetchHistory(userId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHistory(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _api.get('/attendance/history', queryParameters: {'userId': userId});
      _history = res is List ? res : [];
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
