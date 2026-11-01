class PassingStation {
  final String name;
  final String estimatedTime;
  final double distanceKm;

  const PassingStation({
    required this.name,
    required this.estimatedTime,
    required this.distanceKm,
  });
}

class StoppageInfo {
  final String stationName;
  final String stationCode;
  final String scheduledArrival;
  final String scheduledDeparture;
  final String actualArrival;
  final String actualDeparture;
  final int delayMinutes;
  final String platformNumber; // e.g. "PF 1", "PF 2", "PF N"
  final double distanceKm;
  final bool isDeparted;
  final bool isCurrentStation;
  final List<PassingStation> intermediateStations;
  final Map<String, int> fares; // e.g. {'shovon': 380, 'snigdha': 725, 'ac_seat': 865, 'ac_berth': 1300}

  const StoppageInfo({
    required this.stationName,
    required this.stationCode,
    required this.scheduledArrival,
    required this.scheduledDeparture,
    required this.actualArrival,
    required this.actualDeparture,
    this.delayMinutes = 0,
    this.platformNumber = "PF 1",
    this.distanceKm = 0.0,
    this.isDeparted = false,
    this.isCurrentStation = false,
    this.intermediateStations = const [],
    this.fares = const {},
  });

  bool get isOnTime => delayMinutes <= 2;
  String get delayStatusText {
    if (delayMinutes <= 0) return "সময়মতো";
    if (delayMinutes < 60) return "$delayMinutes মিনিট দেরি";
    final h = delayMinutes ~/ 60;
    final m = delayMinutes % 60;
    return "$h ঘ $m মি দেরি";
  }
}
