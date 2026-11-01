class PrayerTimeModel {
  final String hijriDate;
  final String dateString;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String sunrise;
  final String sunset;
  final String sehriEnd;
  final String iftarTime;
  final String currentWaqt;
  final String timeRemaining;
  final String sehriRemaining;

  const PrayerTimeModel({
    required this.hijriDate,
    required this.dateString,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sunrise,
    required this.sunset,
    required this.sehriEnd,
    required this.iftarTime,
    required this.currentWaqt,
    required this.timeRemaining,
    required this.sehriRemaining,
  });

  factory PrayerTimeModel.seed() {
    return const PrayerTimeModel(
      hijriDate: "২০ জমাদিউল আউয়াল",
      dateString: "আজ, ১ নভে • ২০ জমাদিউল আউয়াল",
      fajr: "4:৫০ AM",
      dhuhr: "11:৪৫ AM",
      asr: "3:৪৮ PM",
      maghrib: "5:২৪ PM",
      isha: "6:৪০ PM",
      sunrise: "৬:০৬ AM",
      sunset: "৫:২৪ PM",
      sehriEnd: "4:৫০ AM",
      iftarTime: "5:২৫ PM",
      currentWaqt: "এশা চলছে",
      timeRemaining: "৬:৫২:০২",
      sehriRemaining: "৬:৫২:০২",
    );
  }
}
