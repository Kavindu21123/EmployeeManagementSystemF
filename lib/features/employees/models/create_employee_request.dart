class CreateEmployeeRequest {
  final String firstName;
  final String lastName;
  final double salary;
  final int departmentId;

  CreateEmployeeRequest({
    required this.firstName,
    required this.lastName,
    required this.salary,
    required this.departmentId,
  });

  // Converts the Dart object into JSON for the C# backend
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'salary': salary,
      'departmentId': departmentId,
    };
  }
}