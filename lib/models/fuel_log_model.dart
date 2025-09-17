class FuelLog {
  final String driverName;
  final String vehicleNumber;
  final String odometerImageUrl;
  final String fuelMachineImageUrl;
  final double fuelFilled;
  final double distanceTravelled;
  final double mileage;
  final String dateTime;

  FuelLog({
    required this.driverName,
    required this.vehicleNumber,
    required this.odometerImageUrl,
    required this.fuelMachineImageUrl,
    required this.fuelFilled,
    required this.distanceTravelled,
    required this.mileage,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
    'driverName': driverName,
    'vehicleNumber': vehicleNumber,
    'odometerImageUrl': odometerImageUrl,
    'fuelMachineImageUrl': fuelMachineImageUrl,
    'fuelFilled': fuelFilled,
    'distanceTravelled': distanceTravelled,
    'mileage': mileage,
    'dateTime': dateTime,
  };

  factory FuelLog.fromJson(Map<String, dynamic> json) {
    return FuelLog(
      driverName: json['driverName'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      odometerImageUrl: json['odometerImageUrl'] ?? '',
      fuelMachineImageUrl: json['fuelMachineImageUrl'] ?? '',
      fuelFilled: (json['fuelFilled'] ?? 0).toDouble(),
      distanceTravelled: (json['distanceTravelled'] ?? 0).toDouble(),
      mileage: (json['mileage'] ?? 0).toDouble(),
      dateTime: json['dateTime'] ?? '',
    );
  }

}
  class GlobalFuelStore {
  static List<FuelLog> fuelLogs = [];

  static void addFuelLog(FuelLog log) {
  fuelLogs.insert(0, log);
  }

  static void clearLogs() {
  fuelLogs.clear();
  }
  }
