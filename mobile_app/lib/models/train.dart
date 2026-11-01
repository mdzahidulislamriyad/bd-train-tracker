import 'package:intl/intl.dart';
import 'stoppage_info.dart';

class Train {
  final int id;
  final String code;
  final String name;
  final String nameBn;
  final String origin;
  final String originBn;
  final String destination;
  final String destinationBn;
  final String depTime;
  final String arrTime;
  final String offDay;
  final String type;
  
  // Real-time tracking & community fields (matching original app)
  final int liveDelayMinutes;
  final double currentSpeed; // km/h
  final String nextStationName;
  final String lastUpdatedTimeAgo;
  final int activePassengersCount;
  final int totalVisits;
  final bool isFavorite;
  final double journeyCompletedPercent;
  final double completedDistanceKm;
  final double totalDistanceKm;
  final List<StoppageInfo> stoppages;

  const Train({
    required this.id,
    required this.code,
    required this.name,
    required this.nameBn,
    required this.origin,
    required this.originBn,
    required this.destination,
    required this.destinationBn,
    required this.depTime,
    required this.arrTime,
    required this.offDay,
    required this.type,
    this.liveDelayMinutes = 0,
    this.currentSpeed = 68.0,
    this.nextStationName = "",
    this.lastUpdatedTimeAgo = "১ মি আগে",
    this.activePassengersCount = 14,
    this.totalVisits = 420,
    this.isFavorite = false,
    this.journeyCompletedPercent = 45.0,
    this.completedDistanceKm = 148.0,
    this.totalDistanceKm = 342.0,
    this.stoppages = const [],
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    return Train(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameBn: json['name_bn'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      originBn: json['origin_bn'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      destinationBn: json['destination_bn'] as String? ?? '',
      depTime: json['dep_time'] as String? ?? '',
      arrTime: json['arr_time'] as String? ?? '',
      offDay: json['off_day'] as String? ?? 'None',
      type: json['type'] as String? ?? 'Intercity',
      liveDelayMinutes: json['delay_minutes'] as int? ?? 0,
      currentSpeed: (json['speed'] as num?)?.toDouble() ?? 64.0,
      nextStationName: json['next_station'] as String? ?? '',
      lastUpdatedTimeAgo: json['updated_ago'] as String? ?? '১ মি আগে',
      activePassengersCount: json['passengers'] as int? ?? 12,
      totalVisits: json['visits'] as int? ?? 350,
      isFavorite: json['is_favorite'] as bool? ?? false,
      journeyCompletedPercent: (json['progress'] as num?)?.toDouble() ?? 50.0,
      completedDistanceKm: (json['completed_km'] as num?)?.toDouble() ?? 120.0,
      totalDistanceKm: (json['total_km'] as num?)?.toDouble() ?? 320.0,
    );
  }

  Train copyWith({
    bool? isFavorite,
    int? liveDelayMinutes,
    double? currentSpeed,
    String? nextStationName,
    String? lastUpdatedTimeAgo,
    int? activePassengersCount,
    List<StoppageInfo>? stoppages,
  }) {
    return Train(
      id: id,
      code: code,
      name: name,
      nameBn: nameBn,
      origin: origin,
      originBn: originBn,
      destination: destination,
      destinationBn: destinationBn,
      depTime: depTime,
      arrTime: arrTime,
      offDay: offDay,
      type: type,
      liveDelayMinutes: liveDelayMinutes ?? this.liveDelayMinutes,
      currentSpeed: currentSpeed ?? this.currentSpeed,
      nextStationName: nextStationName ?? this.nextStationName,
      lastUpdatedTimeAgo: lastUpdatedTimeAgo ?? this.lastUpdatedTimeAgo,
      activePassengersCount: activePassengersCount ?? this.activePassengersCount,
      totalVisits: totalVisits,
      isFavorite: isFavorite ?? this.isFavorite,
      journeyCompletedPercent: journeyCompletedPercent,
      completedDistanceKm: completedDistanceKm,
      totalDistanceKm: totalDistanceKm,
      stoppages: stoppages ?? this.stoppages,
    );
  }

  bool get isOnTime => liveDelayMinutes <= 2;

  String get delayStatusText {
    if (liveDelayMinutes <= 0) return "সময়মতো";
    if (liveDelayMinutes < 60) return "$liveDelayMinutes মিনিট দেরি";
    final h = liveDelayMinutes ~/ 60;
    final m = liveDelayMinutes % 60;
    return "$h ঘণ্টা $m মিনিট দেরি";
  }

  /// Calculates estimated travel duration
  String get travelDuration {
    try {
      final now = DateTime.now();
      final depParts = depTime.split(':').map(int.parse).toList();
      final arrParts = arrTime.split(':').map(int.parse).toList();

      var dep = DateTime(now.year, now.month, now.day, depParts[0], depParts[1]);
      var arr = DateTime(now.year, now.month, now.day, arrParts[0], arrParts[1]);

      if (arr.isBefore(dep)) {
        arr = arr.add(const Duration(days: 1));
      }

      final diff = arr.difference(dep);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      return '${hours}ঘণ্টা ${minutes > 0 ? '$minutes মিনিট' : ''}';
    } catch (_) {
      return '--';
    }
  }

  /// Checks if this train is off today
  bool get isOffToday {
    if (offDay.toLowerCase() == 'none' || offDay.isEmpty) return false;
    final today = DateFormat('EEEE').format(DateTime.now());
    return offDay.toLowerCase() == today.toLowerCase();
  }

  /// Bengali day name for off-day
  String get offDayBn {
    switch (offDay.toLowerCase()) {
      case 'sunday':
        return 'রবিবার';
      case 'monday':
        return 'সোমবার';
      case 'tuesday':
        return 'মঙ্গলবার';
      case 'wednesday':
        return 'বুধবার';
      case 'thursday':
        return 'বৃহস্পতিবার';
      case 'friday':
        return 'শুক্রবার';
      case 'saturday':
        return 'শনিবার';
      default:
        return 'ছুটি নেই';
    }
  }
}
