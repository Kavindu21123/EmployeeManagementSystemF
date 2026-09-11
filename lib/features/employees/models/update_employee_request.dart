class UpdateEmployeeRequest {
  final int id;
  final String firstName;
  final String lastName;
  final double salary;

  UpdateEmployeeRequest({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.salary,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'salary': salary,
    };
  }
}