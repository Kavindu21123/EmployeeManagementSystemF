import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/views/login_screen.dart';

void main() {
  // ProviderScope is mandatory! It holds the state for all our providers (Dio, AuthController, etc.)
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Portal',
      debugShowCheckedModeBanner: false, // Removes the red 'DEBUG' banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // We set our brand new LoginScreen as the very first page
      home: LoginScreen(), 
    );
  }
}