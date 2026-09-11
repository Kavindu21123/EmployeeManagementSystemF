import 'package:flutter/material.dart';
import 'login_screen.dart'; // Update this path to point to your actual login screen file

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        // This removes the physical "back" arrow so they can't accidentally go back to the login screen
        automaticallyImplyLeading: false, 
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                // LOGOUT LOGIC: Sends them back to the login screen and destroys the dashboard route
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>  LoginScreen()), // Ensure this matches your login class name
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}