import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  // We inject the secure storage vault so the interceptor can read from it
  final FlutterSecureStorage secureStorage;

  AuthInterceptor(this.secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 1. Fetch the saved JWT using the exact constant string we defined in Phase 2
    final token = await secureStorage.read(key: AppConstants.tokenKey);

    // 2. If a token exists (the user is logged in), attach it to the header
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 3. Release the paused request and send it to the ASP.NET API
    return handler.next(options);
  }
}