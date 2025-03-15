import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  final Dio _dio = Dio();

  factory ApiService() => _instance;

  ApiService._internal() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      return await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }

  Future<Response> get(String endpoint) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      return await _dio.get(
        endpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } catch (e) {
      throw ApiErrorHandler.handleError(e);
    }
  }
}
class AppConstants {
  static const String baseUrl =
      "https://business.city-link.co.in/testingstorage";
  static const String loginEndpoint = "auth/signin";
}

class ApiErrorHandler {
  static final Logger logger = Logger();

  static String handleError(dynamic error) {
    if (error is DioException) {
      String message;
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          message = "Connection timeout!";
          logger.e(message); // Red
          break;
        case DioExceptionType.receiveTimeout:
          message = "Receive timeout!";
          logger.w(message); // Yellow
          break;
        case DioExceptionType.badResponse:
          message = "Invalid response: ${error.response?.data}";
          logger.e(message); // Red
          break;
        case DioExceptionType.cancel:
          message = "Request was cancelled!";
          logger.i(message); // Blue
          break;
        default:
          message = "Unknown network error!";
          logger.d(message); // Cyan
      }
      return message;
    } else {
      logger.e("Unexpected error occurred!");
      return "Unexpected error occurred!";
    }
  }
}
