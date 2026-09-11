import 'package:dio/dio.dart';
import 'package:employee_frontend/features/employees/models/create_employee_request.dart';
import 'package:employee_frontend/features/employees/models/update_employee_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../models/employee.dart';
import '../../../../core/network/api_error_handler.dart'; // Add this import

class EmployeeRepository {
  final Dio _dio;

  EmployeeRepository(this._dio);



  Future<List<Employee>> getEmployees() async {
    try {
      final response = await _dio.get('/employee');
      final List<dynamic> data = response.data;
      return data.map((json) => Employee.fromJson(json)).toList();
    } catch (e) {
      // Pass the error to the global handler!
      throw Exception(ApiErrorHandler.getMessage(e));
    }
  }

  Future<void> createEmployee(CreateEmployeeRequest request) async {
    try {
      await _dio.post('/employee', data: request.toJson());
    } catch (e) {
      // Pass the error to the global handler!
      throw Exception(ApiErrorHandler.getMessage(e));
    }
  }

    Future<void> updateEmployee(int id, UpdateEmployeeRequest request) async {
    try {
      // Sends a PUT request to http://10.0.2.2:5100/api/employee/5
      await _dio.put('/employee/$id', data: request.toJson());
    } catch (e) {
      // We get to use the brilliant global error handler we just built!
      throw Exception(ApiErrorHandler.getMessage(e));
    }
  }


    Future<void> deleteEmployee(int id) async {
    try {
      // Sends a DELETE request to http://10.0.2.2:5100/api/employee/5
      await _dio.delete('/employee/$id');
    } catch (e) {
      // Handled beautifully by our centralized error class
      throw Exception(ApiErrorHandler.getMessage(e));
    }
  }

}

// Riverpod provider for the repository
final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return EmployeeRepository(dioClient.dio);
});