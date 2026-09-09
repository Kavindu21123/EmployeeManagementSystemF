import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import 'auth_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient(FlutterSecureStorage secureStorage) {
    dio = Dio(
      BaseOptions(
        // Automatically targets your ASP.NET Core API
        baseUrl: ApiConstants.baseUrl,
        
        // If the backend doesn't answer in 10 seconds, throw an error instead of freezing
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        
        // Tell the backend we are speaking JSON
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 1. Attach our custom Middleware to inject the JWT token
    dio.interceptors.add(AuthInterceptor(secureStorage));
    
    // 2. Attach the built-in Logger to print network traffic to the terminal
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }
}