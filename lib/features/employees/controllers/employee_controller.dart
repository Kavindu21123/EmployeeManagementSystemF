import 'package:employee_frontend/features/employees/models/create_employee_request.dart';
import 'package:employee_frontend/features/employees/models/update_employee_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/employee.dart';
import '../repositories/employee_repository.dart';

// AsyncNotifier automatically gives us .loading(), .data(), and .error() states!
class EmployeeController extends AsyncNotifier<List<Employee>> {
  
  @override
  Future<List<Employee>> build() async {
    // This runs automatically when the dashboard opens!
    return _fetchEmployees();
  }

  Future<List<Employee>> _fetchEmployees() async {
    final repo = ref.read(employeeRepositoryProvider);
    return await repo.getEmployees();
  }

  Future<String?> addEmployee(CreateEmployeeRequest request) async {
    try {
      final repo = ref.read(employeeRepositoryProvider);
      await repo.createEmployee(request);
      ref.invalidateSelf(); 
      return null; 
    } catch (e) {
      // This strips out the ugly "Exception: " prefix!
      return e.toString().replaceAll('Exception: ', ''); 
    }
  }

  Future<String?> updateEmployee(int id, UpdateEmployeeRequest request) async {
    try {
      final repo = ref.read(employeeRepositoryProvider);
      await repo.updateEmployee(id, request);
      
      // Invalidate the list so it fetches the fresh data from the C# database!
      ref.invalidateSelf(); 
      
      return null; // Success!
    } catch (e) {
      return e.toString().replaceAll('Exception: ', ''); // Clean error message
    }
  }

  Future<String?> deleteEmployee(int id) async {
    try {
      final repo = ref.read(employeeRepositoryProvider);
      await repo.deleteEmployee(id);
      
      // Destroys the old list and fetches the fresh database without the deleted user
      ref.invalidateSelf(); 
      
      return null; // Success!
    } catch (e) {
      return e.toString().replaceAll('Exception: ', ''); // Clean error message
    }
  }


  // Optional: A method to manually refresh the list later
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchEmployees());
  }
}

final employeeControllerProvider = AsyncNotifierProvider<EmployeeController, List<Employee>>(() {
  return EmployeeController();
});