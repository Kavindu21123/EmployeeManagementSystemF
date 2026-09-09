class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  // This converts our Dart object into the exact JSON your ASP.NET API expects
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}