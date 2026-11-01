class PrayerTimeModel {
  final String dateString;
  final String sehriEnd;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String iftar;
  final String isha;
  final String nextWaqtName;
  final String timeRemaining;

  const PrayerTimeModel({
    required this.dateString,
    required this.sehriEnd,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.iftar,
    required this.isha,
    required this.nextWaqtName,
    required this.timeRemaining,
  });

  static PrayerTimeModel getTodayPrayerTimes() {
    final now = DateTime.now();
    // Default Bangladesh Islamic Foundation schedule approximation
    return const PrayerTimeModel(
      dateString: "আজকের নামাজের সময়সূচি (ঢাকা)",
      sehriEnd: "০৪:৫২ AM",
      fajr: "০৪:৫৮ AM",
      dhuhr: "১১:৪৬ AM",
      asr: "০৩:৪৩ PM",
      maghrib: "০৫:১৯ PM",
      iftar: "০৫:১৯ PM",
      isha: "০৬:৩৫ PM",
      nextWaqtName: "মাগরিব",
      timeRemaining: "১ ঘ ২৪ মি বাকি",
    );
  }
}
