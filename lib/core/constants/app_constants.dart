class AppConstants {

  // 10.0.2.2 points to the Windows localhost.
  // We use port 5100 (HTTP) to avoid Android emulator SSL certificate errors.
  static const String baseUrl = 'http://10.0.2.2:5100/api';


  // Secure Storage Keys
  static const String tokenKey = 'jwt_token';
  static const String roleKey = 'user_role';
}