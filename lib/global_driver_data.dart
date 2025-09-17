class GlobalDriverData  {
  final String name;
  final String middleName;
  final String lastName;
  final String age;
  final String address;
  final String experience;
  final String bloodGroup;
  final String dob;
  final String gender;

  GlobalDriverData ({
    required this.name,
    required this.middleName,
    required this.lastName,
    required this.age,
    required this.address,
    required this.experience,
    required this.bloodGroup,
    required this.dob,
    required this.gender,
  });
}

// Global list to hold all signed-up driver logs (latest first)
List<GlobalDriverData > globalDriverLogs = [];
