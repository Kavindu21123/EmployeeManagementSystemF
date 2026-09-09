class AuthResponse {
  final String token;
  // You can add other fields here later if your API returns them, like 'role' or 'expiration'

  AuthResponse({
    required this.token,
  });

  // This converts the raw backend JSON into a safe Dart object
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
    );
  }
}