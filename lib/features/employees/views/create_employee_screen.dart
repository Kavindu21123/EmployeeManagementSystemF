import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/employee_controller.dart';
import '../models/create_employee_request.dart';

class CreateEmployeeScreen extends ConsumerStatefulWidget {
  const CreateEmployeeScreen({super.key});

  @override
  ConsumerState<CreateEmployeeScreen> createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends ConsumerState<CreateEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers to read the text input
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _salaryController = TextEditingController();
  final _departmentIdController = TextEditingController(); // Assuming int (1 = IT, 2 = HR, etc.)

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = CreateEmployeeRequest(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      salary: double.parse(_salaryController.text.trim()),
      departmentId: int.parse(_departmentIdController.text.trim()),
    );

    // Call the controller
    final errorMessage = await ref.read(employeeControllerProvider.notifier).addEmployee(request);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee created successfully!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Go back to the dashboard
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Employee')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // FIRST NAME
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First name is required.';
                  }
                  if (value.trim().length < 2) {
                    return 'First name must be at least 2 characters.';
                  }
                  return null; // Null means the input is valid!
                },
              ),
              const SizedBox(height: 16),
              
              // LAST NAME
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Last name is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // SALARY
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(
                  labelText: 'Salary', 
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Salary is required.';
                  }
                  // Try to parse the string into a double
                  final salary = double.tryParse(value.trim());
                  if (salary == null) {
                    return 'Please enter a valid number.';
                  }
                  if (salary < 0) {
                    return 'Salary cannot be negative.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // DEPARTMENT ID
              TextFormField(
                controller: _departmentIdController,
                decoration: const InputDecoration(
                  labelText: 'Department ID (e.g., 1)', 
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.domain),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done, // Changes the keyboard return key to "Done"
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Department ID is required.';
                  }
                  // Try to parse the string into an integer
                  final deptId = int.tryParse(value.trim());
                  if (deptId == null) {
                    return 'Please enter a valid whole number.';
                  }
                  if (deptId <= 0) {
                    return 'Department ID must be greater than zero.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // SUBMIT BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading 
                    ? const CircularProgressIndicator() 
                    : const Text('Create Employee', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}