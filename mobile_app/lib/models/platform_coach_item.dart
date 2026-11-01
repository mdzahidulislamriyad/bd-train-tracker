enum CoachClassType {
  engine,
  powerCar,
  guardVan,
  shovonChair,
  snigdha,
  acBerth,
  acCabin,
}

class PlatformCoachItem {
  final String coachCode; // e.g. "ইঞ্জিন", "ক", "খ", "গ", "ঝ", "ট"
  final String coachName; // e.g. "শোভন চেয়ার", "স্নিগ্ধা", "এসি বার্থ"
  final CoachClassType classType;
  final int capacity;
  final bool hasPassengerStanding; // whether user's selected coach matches
  final int platformSegmentNumber; // 1 to 16 along the platform
  final bool isFacingForward; // whether seats inside face forward

  const PlatformCoachItem({
    required this.coachCode,
    required this.coachName,
    required this.classType,
    this.capacity = 70,
    this.hasPassengerStanding = false,
    required this.platformSegmentNumber,
    this.isFacingForward = true,
  });
}

class StationPlatformGuide {
  final String stationName;
  final String platformName; // e.g. "প্ল্যাটফর্ম ৩"
  final String directionDescription; // e.g. "চট্টগ্রামের দিকে ট্রেন ছুটবে"
  final int footbridgeSegment; // segment near footbridge/stairs
  final List<PlatformCoachItem> coaches;

  const StationPlatformGuide({
    required this.stationName,
    required this.platformName,
    required this.directionDescription,
    this.footbridgeSegment = 6,
    required this.coaches,
  });
}
