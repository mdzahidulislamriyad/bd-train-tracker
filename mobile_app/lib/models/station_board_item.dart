enum BoardTrainType {
  arrival,
  departure,
}

class StationBoardItem {
  final String trainNumber;
  final String trainName;
  final String destination;
  final String origin;
  final String scheduledTime;
  final String expectedTime;
  final int delayMinutes;
  final String platform;
  final BoardTrainType type;
  final String statusDescription; // e.g. "প্ল্যাটফর্মে প্রবেশ করছে", "বিলম্বিত", "সময়মতো"

  const StationBoardItem({
    required this.trainNumber,
    required this.trainName,
    required this.destination,
    required this.origin,
    required this.scheduledTime,
    required this.expectedTime,
    this.delayMinutes = 0,
    required this.platform,
    required this.type,
    required this.statusDescription,
  });

  bool get isOnTime => delayMinutes <= 0;
}
