enum ReportType {
  lost,
  found,
}

enum ItemCategory {
  bag,
  electronics,
  documents,
  wallet,
  jewelry,
  clothing,
  other,
}

extension ReportTypeExt on ReportType {
  String get labelBn => this == ReportType.lost ? 'হারিয়ে গেছে' : 'পাওয়া গেছে';
}

extension ItemCategoryExt on ItemCategory {
  String get labelBn {
    switch (this) {
      case ItemCategory.bag:
        return 'ব্যাগ ও লাগেজ';
      case ItemCategory.electronics:
        return 'মোবাইল ও ইলেকট্রনিক্স';
      case ItemCategory.documents:
        return 'কাগজপত্র ও আইডি';
      case ItemCategory.wallet:
        return 'মানিব্যাগ ও টাকা';
      case ItemCategory.jewelry:
        return 'গহনা ও মূল্যবান বস্তু';
      case ItemCategory.clothing:
        return 'পোশাক ও চাদর';
      case ItemCategory.other:
        return 'অন্যান্য সামগ্রী';
    }
  }

  String get iconEmoji {
    switch (this) {
      case ItemCategory.bag:
        return '🎒';
      case ItemCategory.electronics:
        return '📱';
      case ItemCategory.documents:
        return '📄';
      case ItemCategory.wallet:
        return '👛';
      case ItemCategory.jewelry:
        return '💍';
      case ItemCategory.clothing:
        return '🧥';
      case ItemCategory.other:
        return '📦';
    }
  }
}

class LostFoundItem {
  final String id;
  final ReportType type;
  final ItemCategory category;
  final String title;
  final String trainName;
  final String trainCode;
  final String compartment;
  final DateTime date;
  final String description;
  final String contactName;
  final String contactPhone;
  final bool isResolved;
  final int claimCount;

  const LostFoundItem({
    required this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.trainName,
    required this.trainCode,
    required this.compartment,
    required this.date,
    required this.description,
    required this.contactName,
    required this.contactPhone,
    this.isResolved = false,
    this.claimCount = 0,
  });

  factory LostFoundItem.fromJson(Map<String, dynamic> json) {
    return LostFoundItem(
      id: json['id'] as String? ?? '',
      type: json['type'] == 'found' ? ReportType.found : ReportType.lost,
      category: ItemCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => ItemCategory.other,
      ),
      title: json['title'] as String? ?? '',
      trainName: json['train_name'] as String? ?? '',
      trainCode: json['train_code'] as String? ?? '',
      compartment: json['compartment'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      description: json['description'] as String? ?? '',
      contactName: json['contact_name'] as String? ?? '',
      contactPhone: json['contact_phone'] as String? ?? '',
      isResolved: json['is_resolved'] as bool? ?? false,
      claimCount: json['claim_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'category': category.name,
      'title': title,
      'train_name': trainName,
      'train_code': trainCode,
      'compartment': compartment,
      'date': date.toIso8601String(),
      'description': description,
      'contact_name': contactName,
      'contact_phone': contactPhone,
      'is_resolved': isResolved,
      'claim_count': claimCount,
    };
  }
}
