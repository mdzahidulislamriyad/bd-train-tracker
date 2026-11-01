class StationFacility {
  final String id;
  final String stationName;
  final String stationNameBn;
  final FacilityCategory category;
  final String titleBn;
  final String platform;
  final String locationHint;
  final double lat;
  final double lng;
  final String openHours;
  final bool isFree;
  final int upvotes;
  final bool isVerified;

  const StationFacility({
    required this.id,
    required this.stationName,
    required this.stationNameBn,
    required this.category,
    required this.titleBn,
    required this.platform,
    required this.locationHint,
    required this.lat,
    required this.lng,
    this.openHours = '২৪ ঘণ্টা খোলা',
    this.isFree = true,
    this.upvotes = 15,
    this.isVerified = true,
  });

  factory StationFacility.fromJson(Map<String, dynamic> json) {
    return StationFacility(
      id: json['id'] as String? ?? '',
      stationName: json['station_name'] as String? ?? '',
      stationNameBn: json['station_name_bn'] as String? ?? '',
      category: FacilityCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => FacilityCategory.other,
      ),
      titleBn: json['title_bn'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      locationHint: json['location_hint'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      openHours: json['open_hours'] as String? ?? '২৪ ঘণ্টা খোলা',
      isFree: json['is_free'] as bool? ?? true,
      upvotes: json['upvotes'] as int? ?? 0,
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station_name': stationName,
      'station_name_bn': stationNameBn,
      'category': category.name,
      'title_bn': titleBn,
      'platform': platform,
      'location_hint': locationHint,
      'lat': lat,
      'lng': lng,
      'open_hours': openHours,
      'is_free': isFree,
      'upvotes': upvotes,
      'is_verified': isVerified,
    };
  }
}

enum FacilityCategory {
  prayerRoom,
  toilet,
  drinkingWater,
  waitingRoom,
  ticketCounter,
  food,
  police,
  wheelchair,
  other,
}

extension FacilityCategoryExt on FacilityCategory {
  String get labelBn {
    switch (this) {
      case FacilityCategory.prayerRoom:
        return 'নামাজের স্থান';
      case FacilityCategory.toilet:
        return 'টয়লেট ও শৌচাগার';
      case FacilityCategory.drinkingWater:
        return 'বিশুদ্ধ খাবার পানি';
      case FacilityCategory.waitingRoom:
        return 'বিশ্রামাগার';
      case FacilityCategory.ticketCounter:
        return 'টিকিট কাউন্টার';
      case FacilityCategory.food:
        return 'খাবার ও ক্যাফে';
      case FacilityCategory.police:
        return 'রেলওয়ে পুলিশ/সহায়তা';
      case FacilityCategory.wheelchair:
        return 'হুইলচেয়ার ও র‍্যাম্প';
      case FacilityCategory.other:
        return 'অন্যান্য সুবিধা';
    }
  }

  String get iconAsset {
    switch (this) {
      case FacilityCategory.prayerRoom:
        return '🕌';
      case FacilityCategory.toilet:
        return '🚻';
      case FacilityCategory.drinkingWater:
        return '💧';
      case FacilityCategory.waitingRoom:
        return '🛋️';
      case FacilityCategory.ticketCounter:
        return '🎫';
      case FacilityCategory.food:
        return '☕';
      case FacilityCategory.police:
        return '👮';
      case FacilityCategory.wheelchair:
        return '♿';
      case FacilityCategory.other:
        return '📍';
    }
  }
}
