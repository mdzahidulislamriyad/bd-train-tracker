import 'package:intl/intl.dart';

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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'name_bn': nameBn,
      'origin': origin,
      'origin_bn': originBn,
      'destination': destination,
      'destination_bn': destinationBn,
      'dep_time': depTime,
      'arr_time': arrTime,
      'off_day': offDay,
      'type': type,
    };
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
