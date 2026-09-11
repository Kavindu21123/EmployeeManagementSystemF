import 'package:dio/dio.dart';

class ApiErrorHandler {
  // A static method so we can call it anywhere without creating an object
  static String getMessage(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        final data = error.response!.data;

        // Map status codes to human-readable messages
        if (statusCode == 400) {
          return (data is String && data.isNotEmpty) 
              ? data 
              : 'Invalid details provided. Please check your inputs.';
        }
        if (statusCode == 401) {
          return 'Your session has expired. Please log out and log back in.';
        }
        if (statusCode == 403) {
          return 'You do not have permission to perform this action.';
        }
        if (statusCode == 500) {
          return 'The server encountered an error. Please try again later.';
        }
        
        return 'An error occurred (Code: $statusCode).';
      }
      // If there is no response, it means the server couldn't be reached
      return 'Network error. Please check your internet connection.';
    }
    
    // Fallback for non-Dio errors (like JSON parsing issues)
    return 'An unexpected error occurred.';
  }
}