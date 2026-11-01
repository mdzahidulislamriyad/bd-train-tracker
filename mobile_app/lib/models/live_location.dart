import 'package:latlong2/latlong.dart';

class LiveLocation {
  final String trainCode;
  final String trainName;
  final LatLng position;
  final double speedKmh;
  final String nearestStation;
  final String nextStation;
  final DateTime lastUpdated;
  final int activePassengers;
  final bool isLive;

  const LiveLocation({
    required this.trainCode,
    required this.trainName,
    required this.position,
    required this.speedKmh,
    required this.nearestStation,
    required this.nextStation,
    required this.lastUpdated,
    this.activePassengers = 1,
    this.isLive = true,
  });

  factory LiveLocation.fromJson(Map<String, dynamic> json) {
    return LiveLocation(
      trainCode: json['train_code'] as String? ?? '',
      trainName: json['train_name'] as String? ?? '',
      position: LatLng(
        (json['lat'] as num?)?.toDouble() ?? 23.8103,
        (json['lng'] as num?)?.toDouble() ?? 90.4125,
      ),
      speedKmh: (json['speed'] as num?)?.toDouble() ?? 0.0,
      nearestStation: json['nearest_station'] as String? ?? '',
      nextStation: json['next_station'] as String? ?? '',
      lastUpdated: DateTime.tryParse(json['last_updated'] as String? ?? '') ?? DateTime.now(),
      activePassengers: json['active_passengers'] as int? ?? 1,
      isLive: json['is_live'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'train_code': trainCode,
      'train_name': trainName,
      'lat': position.latitude,
      'lng': position.longitude,
      'speed': speedKmh,
      'nearest_station': nearestStation,
      'next_station': nextStation,
      'last_updated': lastUpdated.toIso8601String(),
      'active_passengers': activePassengers,
      'is_live': isLive,
    };
  }
}
