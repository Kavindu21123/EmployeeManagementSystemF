import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_providers.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';

class AuthRepository {
  final DioClient _dioClient;
  final FlutterSecureStorage _secureStorage;

  // We pass in Dio and Secure Storage through the constructor (Dependency Injection)
  AuthRepository(this._dioClient, this._secureStorage);

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      // 1. Send the POST request to your C# backend
      final response = await _dioClient.dio.post(
        ApiConstants.loginEndpoint,
        data: request.toJson(),
      );

      // 2. Convert the backend's JSON reply into our secure Dart object
      final authResponse = AuthResponse.fromJson(response.data);

      // 3. Save the JWT token into the phone's encrypted vault
      await _secureStorage.write(
        key: AppConstants.tokenKey, 
        value: authResponse.token,
      );

      return authResponse;
      
    } on DioException catch (e) {
      // This catches exact HTTP errors from ASP.NET (like 401 Unauthorized for bad passwords)
      final errorMessage = e.response?.data ?? 'Invalid email or password';
      throw Exception('Login failed: $errorMessage');
    } catch (e) {
      // This catches standard crashes (like the phone losing internet)
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> logout() async {
    // This securely erases the JWT from the device
    await _secureStorage.delete(key: AppConstants.tokenKey);
  }



}

// ---------------------------------------------------------------------------
// RIVERPOD PROVIDER (Dependency Injection)
// ---------------------------------------------------------------------------
// Any UI screen that needs to log in will simply ask Riverpod for this provider.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  
  return AuthRepository(dioClient, secureStorage);
});