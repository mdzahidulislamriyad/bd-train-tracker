class Station {
  final int id;
  final String code;
  final String name;
  final String nameBn;
  final double lat;
  final double lng;

  const Station({
    required this.id,
    required this.code,
    required this.name,
    required this.nameBn,
    required this.lat,
    required this.lng,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameBn: json['name_bn'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'name_bn': nameBn,
      'lat': lat,
      'lng': lng,
    };
  }

  /// Search matching helper for both English and Bengali queries
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        nameBn.contains(q) ||
        code.toLowerCase().contains(q);
  }
}
