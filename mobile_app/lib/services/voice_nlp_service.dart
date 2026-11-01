import '../models/station.dart';
import '../models/train.dart';
import 'railway_data_service.dart';

class VoiceQueryResult {
  final String queryText;
  final String spokenResponseBn;
  final List<Train> matchedTrains;
  final Station? fromStation;
  final Station? toStation;
  final bool hasResults;

  const VoiceQueryResult({
    required this.queryText,
    required this.spokenResponseBn,
    required this.matchedTrains,
    this.fromStation,
    this.toStation,
    required this.hasResults,
  });
}

class VoiceNlpService {
  static final VoiceNlpService _instance = VoiceNlpService._internal();
  factory VoiceNlpService() => _instance;
  VoiceNlpService._internal();

  final RailwayDataService _dataService = RailwayDataService();

  /// Parse natural language spoken Bengali text into train query
  VoiceQueryResult parseBengaliQuery(String query) {
    final text = query.trim().toLowerCase();
    final allTrains = _dataService.trains;
    final allStations = _dataService.stations;

    // 1. Direct Specific Train Name Query
    // Example: "সুবর্ণ এক্সপ্রেস কখন ছাড়বে" or "সোনার বাংলা"
    for (var train in allTrains) {
      if (text.contains(train.nameBn.toLowerCase()) ||
          text.contains(train.name.toLowerCase()) ||
          text.contains(train.code)) {
        return VoiceQueryResult(
          queryText: query,
          spokenResponseBn:
              '${train.nameBn} (${train.code}) ${train.originBn} থেকে ${train.depTime} টায় ছেড়ে ${train.destinationBn} পৌঁছাবে ${train.arrTime} টায়। ${train.isOffToday ? 'আজ ছুটি।' : 'আজ ট্রেনটি চলবে।'}',
          matchedTrains: [train],
          hasResults: true,
        );
      }
    }

    // 2. Station-to-Station Route Query
    // Look for origin and destination patterns: e.g. "ঢাকা থেকে চট্টগ্রাম", "সিলেটের ট্রেন"
    Station? detectedFrom;
    Station? detectedTo;

    // Identify mentioned stations
    final mentionedStations = <Station>[];
    for (var station in allStations) {
      final nameEn = station.name.toLowerCase();
      final nameBn = station.nameBn.toLowerCase();

      if (nameBn.isNotEmpty && text.contains(nameBn)) {
        mentionedStations.add(station);
      } else if (nameEn.length > 3 && text.contains(nameEn)) {
        mentionedStations.add(station);
      }
    }

    if (mentionedStations.length >= 2) {
      // E.g. "ঢাকা থেকে চট্টগ্রাম" -> first is from, second is to
      detectedFrom = mentionedStations[0];
      detectedTo = mentionedStations[1];
    } else if (mentionedStations.length == 1) {
      // E.g. "কক্সবাজার যাওয়ার ট্রেন" -> default from Dhaka to mentioned
      final target = mentionedStations[0];
      if (target.name.toLowerCase() != 'dhaka') {
        detectedFrom = allStations.firstWhere(
          (s) => s.name.toLowerCase() == 'dhaka',
          orElse: () => allStations.first,
        );
        detectedTo = target;
      } else {
        detectedFrom = target;
      }
    }

    if (detectedFrom != null && detectedTo != null) {
      final trains = _dataService.findTrainsBetween(
        from: detectedFrom,
        to: detectedTo,
      );

      final countBn = trains.length.toString();
      return VoiceQueryResult(
        queryText: query,
        spokenResponseBn: trains.isNotEmpty
            ? '${detectedFrom.nameBn} থেকে ${detectedTo.nameBn} রুটে $countBnটি আন্তঃনগর ট্রেন পাওয়া গেছে।'
            : '${detectedFrom.nameBn} থেকে ${detectedTo.nameBn} রুটে কোনো সরাসরি ট্রেন পাওয়া যায়নি।',
        matchedTrains: trains,
        fromStation: detectedFrom,
        toStation: detectedTo,
        hasResults: trains.isNotEmpty,
      );
    }

    // 3. Fallback: Search all trains matching words
    final matches = allTrains.where((t) {
      return text.contains(t.destinationBn.toLowerCase()) ||
          text.contains(t.originBn.toLowerCase()) ||
          text.contains(t.nameBn.toLowerCase());
    }).toList();

    if (matches.isNotEmpty) {
      return VoiceQueryResult(
        queryText: query,
        spokenResponseBn: 'আপনার প্রশ্নের সাথে মিলে এমন ${matches.length}টি ট্রেন পাওয়া গেছে।',
        matchedTrains: matches,
        hasResults: true,
      );
    }

    return VoiceQueryResult(
      queryText: query,
      spokenResponseBn: 'দুঃখিত, কোনো ট্রেন বা স্টেশনের তথ্য মেলেনি। আবার স্পষ্ট করে বলুন।',
      matchedTrains: const [],
      hasResults: false,
    );
  }
}
