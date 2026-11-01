import '../models/lost_found_item.dart';

class LostFoundService {
  static final LostFoundService _instance = LostFoundService._internal();
  factory LostFoundService() => _instance;
  LostFoundService._internal();

  final List<LostFoundItem> _items = [
    LostFoundItem(
      id: 'lf1',
      type: ReportType.lost,
      category: ItemCategory.bag,
      title: 'কালো রঙের ডেল ল্যাপটপ ব্যাগ',
      trainName: 'সুবর্ণ এক্সপ্রেস',
      trainCode: '702',
      compartment: 'বগি "খ", সিট নম্বর ৩৪-এর ওপর লাগেজ র্যাকে',
      date: DateTime.now().subtract(const Duration(hours: 4)),
      description:
          'কালো রঙের একটি ডেল ল্যাপটপ ব্যাগ ভুলবশত সিটের ওপর ফেলে এসেছি। ব্যাগের ভেতরে জরুরি অফিস ফাইল ও ডেল ল্যাপটপ ছিল। কেউ পেয়ে থাকলে অনুগ্রহ করে যোগাযোগ করবেন। উপযুক্ত পুরষ্কার দেওয়া হবে।',
      contactName: 'ইকবাল মাহমুদ',
      contactPhone: '01711-XXXXXX',
      claimCount: 1,
    ),
    LostFoundItem(
      id: 'lf2',
      type: ReportType.found,
      category: ItemCategory.documents,
      title: 'জাতীয় পরিচয়পত্র (NID) ও মানিব্যাগ পাওয়া গেছে',
      trainName: 'সোনার বাংলা এক্সপ্রেস',
      trainCode: '787',
      compartment: 'বগি "গ", সিট নম্বর ১২',
      date: DateTime.now().subtract(const Duration(hours: 12)),
      description:
          'চট্টগ্রাম যাওয়ার পথে সিটের ফাঁকে একটি খয়েরি রঙের মানিব্যাগ পাওয়া গেছে। ভেতরে একটি স্মার্ট এনআইডি কার্ড (নাম: মো: শফিকুল ইসলাম) ও কিছু টাকা আছে। সঠিক প্রমাণ দিয়ে ফেরত নিতে পারেন। বর্তমানে ঢাকা জিআরপি থানায় জমা আছে।',
      contactName: 'জিআরপি স্টেশন পুলিশ',
      contactPhone: '01819-XXXXXX',
      claimCount: 2,
    ),
    LostFoundItem(
      id: 'lf3',
      type: ReportType.found,
      category: ItemCategory.electronics,
      title: 'স্যামসাং গ্যালাক্সি মোবাইল ফোন',
      trainName: 'কক্সবাজার এক্সপ্রেস',
      trainCode: '814',
      compartment: 'স্নিগ্ধা-১ বগি, জানালার পাশে',
      date: DateTime.now().subtract(const Duration(days: 1)),
      description:
          'চার্জিং পয়েন্টের সাথে কালো রঙের একটি স্যামসাং ফোন লাগানো অবস্থায় পাওয়া যায়। ফোনটি লক করা আছে। উপযুক্ত প্রমাণ দিয়ে যোগাযোগ করুন।',
      contactName: 'আরিফুল হক (সহযাত্রী)',
      contactPhone: '01912-XXXXXX',
      claimCount: 4,
    ),
    LostFoundItem(
      id: 'lf4',
      type: ReportType.lost,
      category: ItemCategory.clothing,
      title: 'বাচ্চাদের লাল শীতের ট্রাভেল জ্যাকেট',
      trainName: 'পারাবত এক্সপ্রেস',
      trainCode: '709',
      compartment: 'শোভন বগি "ক"',
      date: DateTime.now().subtract(const Duration(days: 2)),
      description:
          'সিলেট নামার সময় তাড়াহুড়োয় সিটে লাল রঙের একটি বাচ্চাদের জ্যাকেট ফেলে এসেছি।',
      contactName: 'নাজমিন আক্তার',
      contactPhone: '01610-XXXXXX',
      isResolved: true,
      claimCount: 1,
    ),
  ];

  List<LostFoundItem> getAllItems() => List.unmodifiable(_items);

  List<LostFoundItem> getFilteredItems({
    ReportType? type,
    ItemCategory? category,
  }) {
    return _items.where((item) {
      if (type != null && item.type != type) return false;
      if (category != null && item.category != category) return false;
      return true;
    }).toList();
  }

  void addItem(LostFoundItem item) {
    _items.insert(0, item);
  }
}
