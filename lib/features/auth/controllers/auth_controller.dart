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

  Future<bool> login(String username, String password) async {
  // 1. Update state to Loading (This will make the UI show a loading spinner)
  state = const AsyncValue.loading();

  // 2. Read the repository directly from Riverpod's 'ref'
  final authRepo = ref.read(authRepositoryProvider);

  // 3. AsyncValue.guard automatically catches any backend 401 errors!
  state = await AsyncValue.guard(() async {
    final request = LoginRequest(username: username, password: password);
    await authRepo.login(request);
  });

  // 4. Check if the guard caught an error from the backend.
  // If it has an error, return false (login failed). Otherwise, return true (success)!
  if (state.hasError) {
    return false;
  } else {
    return true;
  }
}
}

// ---------------------------------------------------------------------------
// RIVERPOD PROVIDER (Modern Syntax)
// ---------------------------------------------------------------------------
final authControllerProvider = AsyncNotifierProvider<AuthController, void>(() {
  return AuthController();
});