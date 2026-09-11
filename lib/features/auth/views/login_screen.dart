import 'package:employee_frontend/features/admin/views/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';

// By extending ConsumerWidget, Riverpod allows this screen to listen to our providers
class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  // These controllers grab the raw text typed into the text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. WATCH THE STATE: We listen to the AuthController.
    // Whenever the controller changes to "Loading" or "Error", this screen instantly rebuilds.
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Portal Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email Input
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            
            // Password Input
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true, // Hides the password with dots
            ),
            const SizedBox(height: 24),

            // 2. REACT TO THE STATE: 
            // If the controller says "isLoading", show a spinner. 
            // Otherwise, show the normal Login button.
            authState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                              // Grab the text exactly as typed
                              final userInput = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              // Basic validation so we don't send empty requests
                              if (userInput.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please fill in all fields')),
                                );
                                return;
                              }

                              // 1. Call the backend and WAIT for the boolean result (true or false)
                              final isSuccess = await ref.read(authControllerProvider.notifier).login(userInput, password);

                              // 2. ONLY navigate if the controller explicitly says 'true'
                              if (isSuccess) {
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
                                  );
                                }
                              } else {
                                // 3. If it returns 'false', show the error!
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Invalid credentials. Access denied.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('LOGIN', style: TextStyle(fontSize: 16)),
                  ),
          ],
        ),
      ),
    );
  }
}