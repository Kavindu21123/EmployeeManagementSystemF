class Employee {
  final int id;
  final String firstName;
  final String lastName;
  final double salary; 
  final String departmentName;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.salary,
    required this.departmentName,
  });

  // Factory to convert the JSON from C# into a Dart Object
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      firstName: json['firstName'] ?? 'Unknown',
      lastName: json['lastName'] ?? 'Unknown',
      // C# decimals can sometimes arrive as ints (e.g., 50000 instead of 50000.0)
      // .toDouble() safely handles both integer and double JSON values
      salary: (json['salary'] ?? 0).toDouble(), 
      departmentName: json['departmentName'] ?? 'Unassigned',
    );
  }
}