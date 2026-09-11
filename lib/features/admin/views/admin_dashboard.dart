import 'package:employee_frontend/features/employees/views/create_employee_screen.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../auth/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../employees/views/employee_list_screen.dart';


class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Control Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // logout logic 
              // 1. Erase the token via the controller
              await ref.read(authControllerProvider.notifier).logout();

              // 2. Safely navigate back to the Login Screen
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Ensure you import login_screen.dart!
                  (Route<dynamic> route) => false, // This completely destroys the back-button history
                );
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.admin_panel_settings, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 24),
            
            // 1. READ Button
            _buildMenuButton(
              icon: Icons.people,
              title: 'View All Employees (Read)',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmployeeListScreen()),
                );
              },
            ),
            const SizedBox(height: 16),

            // 2. CREATE Button (Placeholder for now)
            _buildMenuButton(
              icon: Icons.person_add,
              title: 'Add New Employee (Create)',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateEmployeeScreen()),
                );
              },
            ),
            
            // Note: Typically, Update and Delete are placed inside the EmployeeListScreen
            // so you can select *which* employee to update/delete. 
            // But we can add dashboard buttons for them later if you prefer!
          ],
        ),
      ),
    );
  }

  // A helper method to create beautiful, consistent buttons
  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, size: 28),
      label: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: onTap,
    );
  }
}