import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'https://collage-soon-backend.onrender.com/api';
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.response?.data['error'] ?? 'Something went wrong';
    }
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.response?.data['error'] ?? 'Something went wrong';
    }
  }
}
