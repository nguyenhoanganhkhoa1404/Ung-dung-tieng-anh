import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;
  
  ApiClient(this._dio);
  
  // Auth endpoints
  Future<Map<String, dynamic>> verifyToken(String token) async {
    try {
      final response = await _dio.post(
        '/api/auth/verify-token',
        data: {'token': token},
      );
      return response.data;
    } catch (e) {
      throw Exception('Token verification failed: $e');
    }
  }
  
  // Progress endpoints
  Future<Map<String, dynamic>> submitProgress(Map<String, dynamic> progressData) async {
    try {
      final response = await _dio.post(
        '/api/progress/submit',
        data: progressData,
      );
      return response.data;
    } catch (e) {
      throw Exception('Progress submission failed: $e');
    }
  }
  
  // Recommendation endpoints
  Future<List<dynamic>> getRecommendedLessons(String userId) async {
    try {
      final response = await _dio.get(
        '/api/recommend/lesson',
        queryParameters: {'userId': userId},
      );
      return response.data['lessons'];
    } catch (e) {
      throw Exception('Failed to get recommendations: $e');
    }
  }
  
  // Analytics endpoints
  Future<Map<String, dynamic>> getAnalyticsOverview(String userId) async {
    try {
      final response = await _dio.get(
        '/api/analytics/overview',
        queryParameters: {'userId': userId},
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to get analytics: $e');
    }
  }
}

