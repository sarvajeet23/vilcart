import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiErrorHandler {
  static final Logger logger = Logger();

  static String handleError(dynamic error) {
    if (error is DioException) {
      String message;
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          message = "Connection timeout!";
          logger.e(message);
          break;
        case DioExceptionType.receiveTimeout:
          message = "Receive timeout!";
          logger.w(message);
          break;
        case DioExceptionType.badResponse:
          message = "Invalid response: ${error.response?.data}";
          logger.e(message);
          break;
        case DioExceptionType.cancel:
          message = "Request was cancelled!";
          logger.i(message);
          break;
        default:
          message = "Unknown network error!";
          logger.d(message);
      }
      return message;
    } else {
      logger.e("Unexpected error occurred!");
      return "Unexpected error occurred!";
    }
  }
}
