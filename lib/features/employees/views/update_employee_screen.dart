import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/employee_controller.dart';
import '../models/employee.dart';
import '../models/update_employee_request.dart';

class UpdateEmployeeScreen extends ConsumerStatefulWidget {
  final Employee employee; // We pass the selected employee here!

  const UpdateEmployeeScreen({super.key, required this.employee});

  @override
  ConsumerState<UpdateEmployeeScreen> createState() => _UpdateEmployeeScreenState();
}

class _UpdateEmployeeScreenState extends ConsumerState<UpdateEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _salaryController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill the controllers with the existing employee data
    _firstNameController = TextEditingController(text: widget.employee.firstName);
    _lastNameController = TextEditingController(text: widget.employee.lastName);
    _salaryController = TextEditingController(text: widget.employee.salary.toString());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = UpdateEmployeeRequest(
      id: widget.employee.id,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      salary: double.parse(_salaryController.text.trim()),
    );

    final errorMessage = await ref.read(employeeControllerProvider.notifier)
        .updateEmployee(widget.employee.id, request);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee updated successfully!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Go back to the directory
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }
    Future<void> _confirmDelete() async {
    // 1. Show the confirmation popup
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Employee?'),
          content: Text('Are you sure you want to permanently delete ${widget.employee.firstName} ${widget.employee.lastName}? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false), // Cancel
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () => Navigator.pop(dialogContext, true), // Confirm
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    // 2. If the user clicked "Delete", proceed with the API call
    if (confirm == true && mounted) {
      setState(() => _isLoading = true);
      
      final errorMessage = await ref.read(employeeControllerProvider.notifier).deleteEmployee(widget.employee.id);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee deleted successfully.'), backgroundColor: Colors.grey),
        );
        Navigator.pop(context); // Exit the update screen and return to the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Employee'),
      

          actions: [
          // The new Delete button!
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            tooltip: 'Delete Employee',
            onPressed: _isLoading ? null : _confirmDelete,
          ),
        ],

      
      ),
                  
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Display ID (Read-only)
              Text('Employee ID: ${widget.employee.id}', 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 16),

              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(labelText: 'Salary', border: OutlineInputBorder(), prefixIcon: Icon(Icons.attach_money)),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Required';
                  final salary = double.tryParse(value.trim());
                  if (salary == null) return 'Enter a valid number';
                  if (salary < 0) return 'Cannot be negative';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading 
                    ? const CircularProgressIndicator() 
                    : const Text('Save Changes', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}