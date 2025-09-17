class DriverData {
  final String name;
  final String middleName;
  final String lastName;
  final String phone;
  final String age;
  final String address;
  final String experience;
  final String bloodGroup;
  final String dob;
  final String gender;
  final String vehicleNumber;
  final String vehicleType;

  DriverData({
    required this.name,
    required this.middleName,
    required this.lastName,
    required this.phone,
    required this.age,
    required this.address,
    required this.experience,
    required this.bloodGroup,
    required this.dob,
    required this.gender,
    required this.vehicleNumber,
    required this.vehicleType,
  });

  String get fullName => "$name $middleName $lastName";
}

class AttendanceLog {
  final String driverName;
  final String vehicleNumber;
  final String vehicleType;
  final String date;
  final String time;
  final String status;

  AttendanceLog({
    required this.driverName,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.date,
    required this.time,
    required this.status,
  });
}

class GlobalDriverData {
  static final List<DriverData> drivers = [];
  static final List<AttendanceLog> attendanceLogs = [];

  static void addDriver(DriverData data) {
    drivers.insert(0, data); // Newest at top
  }

  static void removeDriver(int index) {
    drivers.removeAt(index);
  }

  static void clearAllDrivers() {
    drivers.clear();
  }

  static void markAttendance(DriverData driver) {
    final now = DateTime.now();
    final date = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final time = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    final alreadyMarked = attendanceLogs.any((log) =>
    log.driverName == driver.fullName && log.date == date);

    if (!alreadyMarked) {
      attendanceLogs.add(AttendanceLog(
        driverName: driver.fullName,
        vehicleNumber: driver.vehicleNumber,
        vehicleType: driver.vehicleType,
        date: date,
        time: time,
        status: "Present",
      ));
    }
  }

  static List<AttendanceLog> getTodayLogs() {
    final now = DateTime.now();
    final today = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return attendanceLogs.where((log) => log.date == today).toList();
  }
}
