import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/login_request.dart';
import '../repositories/auth_repository.dart';

// 1. The Controller class now extends AsyncNotifier
class AuthController extends AsyncNotifier<void> {
  
  // 2. The 'build' method replaces the constructor. This is our initial "Idle" state.
  @override
  FutureOr<void> build() {
    // Initial state is just doing nothing.
  }

  Future<void> login(String email, String password) async {
    // 1. Update state to Loading (This will make the UI show a loading spinner)
    state = const AsyncValue.loading();

    // 2. Read the repository directly from Riverpod's 'ref'
    final authRepo = ref.read(authRepositoryProvider);

    // 3. AsyncValue.guard is magic. It runs the code inside it.
    // If it succeeds, it automatically sets the state to Data(Success).
    // If your ASP.NET backend throws an error, it automatically sets the state to Error!
    state = await AsyncValue.guard(() async {
      final request = LoginRequest(email: email, password: password);
      await authRepo.login(request);
    });
  }
}

// ---------------------------------------------------------------------------
// RIVERPOD PROVIDER (Modern Syntax)
// ---------------------------------------------------------------------------
final authControllerProvider = AsyncNotifierProvider<AuthController, void>(() {
  return AuthController();
});