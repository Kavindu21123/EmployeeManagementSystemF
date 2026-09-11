import 'package:employee_frontend/features/employees/views/update_employee_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/employee_controller.dart';

class EmployeeListScreen extends ConsumerWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the employee state
    final employeeState = ref.watch(employeeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Directory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(employeeControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      body: employeeState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
        ),
        data: (employees) {
          if (employees.isEmpty) {
            return const Center(child: Text('No employees found.'));
          }

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(employee.firstName.isNotEmpty ? employee.firstName[0] : '?'),
                  ),
                  title: Text('${employee.firstName} ${employee.lastName}'),
                  subtitle: Text('${employee.departmentName} • \$${employee.salary.toStringAsFixed(2)}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Update and Delete will likely happen when we click this!
                    // Navigate to the Update screen, passing the selected employee!
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateEmployeeScreen(employee: employee),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}