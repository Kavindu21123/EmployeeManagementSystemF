class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  // This converts our Dart object into the exact JSON your ASP.NET API expects
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}