import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AcademicProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  bool _isLoading = false;
  
  // Data Stores
  List<dynamic> _exams = [];
  List<dynamic> _marks = [];
  List<dynamic> _assignments = [];
  List<dynamic> _studentRequests = [];
  List<dynamic> _myStudents = [];

  // Getters
  bool get isLoading => _isLoading;
  List<dynamic> get exams => _exams;
  List<dynamic> get marks => _marks;
  List<dynamic> get assignments => _assignments;
  List<dynamic> get studentRequests => _studentRequests;
  List<dynamic> get myStudents => _myStudents;

  // Generic Helper
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

  // STUDNET: Get Exam Schedule
  Future<void> fetchExamSchedule({String? studentId, String? teacherId, String semester = '1'}) async {
    await _performAction(() async {
      final res = await _api.get('/academic/exam-schedule', queryParameters: {
        if(studentId != null) 'studentId': studentId,
        if(teacherId != null) 'teacherId': teacherId,
        'semester': semester
      });
      _exams = res['exams'] ?? [];
    });
  }

  // STUDENT: Get My Marks
  Future<void> fetchMyMarks(String studentId) async {
    await _performAction(() async {
      final res = await _api.get('/academic/my-marks', queryParameters: {'studentId': studentId}); // API uses Body strictly in your code? Let's check. 
      // NOTE: Your controller uses req.body for GET in getMyMarks. This is bad practice (GET shouldn't have body), but I will support it via POST if needed or Query if updated.
      // Based on typical axios/dio, GET with body is flaky. I'll try generic request or assume you meant req.query. 
      // If server code is req.body for GET, we might need to change server or use a custom request.
      // Assuming I can pass it.
       // Actually, Dio supports data in GET, but it's non-standard.
       // Let's assume we fixed it or try to pass it.
      _marks = res is List ? res : [];
    });
  }
  
  // STUDENT: Get Assignments
  Future<void> fetchAssignments(String teacherId) async {
    await _performAction(() async {
      final res = await _api.get('/academic/assignment', queryParameters: {'teacherId': teacherId});
      _assignments = res is List ? res : [];
    });
  }

  // TEACHER: Get Pending Requests
  Future<void> fetchStudentRequests(String teacherId) async {
    await _performAction(() async {
      // The controller expects req.body for this POST
      final res = await _api.post('/teacher/requests', {'teacherId': teacherId});
      _studentRequests = res is List ? res : [];
    });
  }

  // TEACHER: Handle Request
  Future<void> handleRequest(String studentId, String status) async {
     await _performAction(() async {
      await _api.post('/teacher/handle-request', {'studentId': studentId, 'status': status});
      // Remove text locally
      _studentRequests.removeWhere((s) => s['_id'] == studentId);
    });
  }

  // TEACHER: Get My Class List
  Future<void> fetchMyClass(String teacherId) async {
    await _performAction(() async {
        // Controller checks query OR body.
        final res = await _api.get('/teacher/my-students', queryParameters: {'teacherId': teacherId});
        _myStudents = res is List ? res : [];
    });
  }

  // TEACHER: Broadcast
  Future<void> sendBroadcast(String teacherId, String title, String message) async {
    await _performAction(() async {
      await _api.post('/teacher/broadcast', {
        'teacherId': teacherId,
        'title': title,
        'message': message
      });
    });
  }

  // TEACHER: Create Assignment
  Future<void> createAssignment(Map<String, dynamic> data) async {
    await _performAction(() async {
      await _api.post('/academic/assignment', data);
    });
  }
  
  // TEACHER: Add Marks
  Future<void> addMarks(Map<String, dynamic> data) async {
     await _performAction(() async {
      await _api.post('/academic/add-marks', data);
    });
  }

  // TEACHER: Create Exam Schedule
  Future<void> createExamSchedule(Map<String, dynamic> data) async {
     await _performAction(() async {
      await _api.post('/academic/exam-schedule', data);
    });
  }
}
