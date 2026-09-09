class ApiConstants {
  // IMPORTANT: Android Emulators cannot use 'localhost' or '127.0.0.1'.
  // 10.0.2.2 is a special alias that points to your Windows host machine's localhost.
  // Note: Change the '5001' to match whatever port your ASP.NET Core API actually runs on!
  static const String baseUrl = 'https://10.0.2.2:5001/api';

  // Feature Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String employeeEndpoint = '/employee';
}