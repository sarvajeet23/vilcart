import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vilcart/core/constants/app_constants.dart';
import 'package:vilcart/core/error/api_error_handler.dart';

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
