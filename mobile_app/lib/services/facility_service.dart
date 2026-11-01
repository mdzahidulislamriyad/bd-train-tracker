import '../models/station_facility.dart';

class FacilityService {
  static final FacilityService _instance = FacilityService._internal();
  factory FacilityService() => _instance;
  FacilityService._internal();

  final List<StationFacility> _facilities = [
    // Dhaka Kamalapur Facilities
    const StationFacility(
      id: 'f1',
      stationName: 'Dhaka',
      stationNameBn: 'ঢাকা (কমলাপুর)',
      category: FacilityCategory.prayerRoom,
      titleBn: 'কেন্দ্রীয় রেলওয়ে মসজিদ ও ওজুখানা',
      platform: 'প্ল্যাটফর্ম ১ এর বাইরে',
      locationHint: 'প্রধান প্রবেশদ্বারের ডান পাশে মসজিদ কমপ্লেক্স, দ্বিতীয় তলা',
      lat: 23.7315,
      lng: 90.4262,
      openHours: 'ফজর থেকে এশা',
      isFree: true,
      upvotes: 42,
      isVerified: true,
    ),
    const StationFacility(
      id: 'f2',
      stationName: 'Dhaka',
      stationNameBn: 'ঢাকা (কমলাপুর)',
      category: FacilityCategory.drinkingWater,
      titleBn: 'ফিল্টার করা বিশুদ্ধ খাবার পানি বুথ',
      platform: 'প্ল্যাটফর্ম ২ ও ৩',
      locationHint: 'ওভারব্রিজের নিচে সিঁড়ির ঠিক সামনে ফিল্টারিং বুথ',
      lat: 23.7320,
      lng: 90.4258,
      openHours: '২৪ ঘণ্টা খোলা',
      isFree: true,
      upvotes: 68,
      isVerified: true,
    ),
    const StationFacility(
      id: 'f3',
      stationName: 'Dhaka',
      stationNameBn: 'ঢাকা (কমলাপুর)',
      category: FacilityCategory.toilet,
      titleBn: 'আধুনিক শৌচাগার ও ওয়াশরুম (পুরুষ/মহিলা)',
      platform: 'প্ল্যাটফর্ম ১ ও ৪',
      locationHint: 'ভিআইপি লাউঞ্জের পেছনে পরিষ্কার-পরিচ্ছন্ন ওয়াশরুম',
      lat: 23.7318,
      lng: 90.4255,
      openHours: '২৪ ঘণ্টা খোলা',
      isFree: false,
      upvotes: 35,
      isVerified: true,
    ),
    const StationFacility(
      id: 'f4',
      stationName: 'Dhaka',
      stationNameBn: 'ঢাকা (কমলাপুর)',
      category: FacilityCategory.waitingRoom,
      titleBn: 'মহিলা ও সাধারণ বিশ্রামাগার (এসি/নন-এসি)',
      platform: 'প্ল্যাটফর্ম ১',
      locationHint: 'প্রধান কনকোর্স হলের ১ তলায় হাতের বামে',
      lat: 23.7314,
      lng: 90.4260,
      openHours: '২৪ ঘণ্টা খোলা',
      isFree: true,
      upvotes: 54,
      isVerified: true,
    ),
    const StationFacility(
      id: 'f5',
      stationName: 'Dhaka',
      stationNameBn: 'ঢাকা (কমলাপুর)',
      category: FacilityCategory.police,
      titleBn: 'রেলওয়ে জিআরপি থানা ও হেল্প ডেস্ক',
      platform: 'প্ল্যাটফর্ম ১',
      locationHint: 'প্রধান টিকিট কাউন্টারের বিপরীত পাশে জিআরপি হেল্প বুথ',
      lat: 23.7312,
      lng: 90.4265,
      openHours: '২৪ ঘণ্টা খোলা',
      isFree: true,
      upvotes: 29,
      isVerified: true,
    ),

    // Dhaka Airport Station Facilities
    const StationFacility(
      id: 'f6',
      stationName: 'Airport',
      stationNameBn: 'বিমানবন্দর রেলওয়ে স্টেশন',
      category: FacilityCategory.drinkingWater,
      titleBn: 'বিনামূল্যে বিশুদ্ধ খাবার পানির কল',
      platform: 'প্ল্যাটফর্ম ১',
      locationHint: 'টিকিট চেক পোস্ট পার হয়ে ডানে ফুটওভার ব্রিজের নিচে',
      lat: 23.8515,
      lng: 90.4075,
      openHours: '২৪ ঘণ্টা খোলা',
      isFree: true,
      upvotes: 45,
      isVerified: true,
    ),
    const StationFacility(
      id: 'f7',
      stationName: 'Airport',
      stationNameBn: 'বিমানবন্দর রেলওয়ে স্টেশন',
      category: FacilityCategory.prayerRoom,
      titleBn: 'নামাজের নির্ধারিত স্থান ও ওজুর জায়গা',
      platform: 'প্ল্যাটফর্ম ২',
      locationHint: 'উত্তর পাশের ফুটওভার ব্রিজের কাছে কাঠের পার্টিশন করা ঘর',
      lat: 23.8520,
      lng: 90.4072,
      openHours: '২৪ ঘণ্টা খোলা',
      isFree: true,
      upvotes: 31,
      isVerified: true,
    ),

    // Chattogram Station Facilities
    const StationFacility(
      id: 'f8',
      stationName: 'Chattogram',
      stationNameBn: 'চট্টগ্রাম পুরাতন ও নতুন স্টেশন',
      category: FacilityCategory.waitingRoom,
      titleBn: 'প্রথম শ্রেণীর আধুনিক এসি লাউঞ্জ ও ওয়েটিং রুম',
      platform: 'প্ল্যাটফর্ম ১',
      locationHint: 'নতুন স্টেশন ভবনের গ্রাউন্ড ফ্লোর, এটিএম বুথের পাশে',
      lat: 22.3340,
      lng: 91.8280,
      openHours: '২৪ ঘণ্টা খোলা',
      isFree: true,
      upvotes: 62,
      isVerified: true,
    ),
    const StationFacility(
      id: 'f9',
      stationName: 'Chattogram',
      stationNameBn: 'চট্টগ্রাম পুরাতন ও নতুন স্টেশন',
      category: FacilityCategory.prayerRoom,
      titleBn: 'চট্টগ্রাম রেলওয়ে স্টেশন জামে মসজিদ',
      platform: 'স্টেশন প্রাঙ্গণ',
      locationHint: 'পার্কিং চত্বরের পশ্চিম প্রান্তে অবস্থিত ঐতিহ্যবাহী মসজিদ',
      lat: 22.3335,
      lng: 91.8285,
      openHours: 'ফজর থেকে এশা',
      isFree: true,
      upvotes: 50,
      isVerified: true,
    ),
  ];

  List<StationFacility> getFacilitiesForStation(String stationName) {
    final query = stationName.trim().toLowerCase();
    return _facilities.where((f) {
      return f.stationName.toLowerCase().contains(query) ||
          f.stationNameBn.toLowerCase().contains(query);
    }).toList();
  }

  List<StationFacility> getAllFacilities() => List.unmodifiable(_facilities);

  void addFacility(StationFacility facility) {
    _facilities.insert(0, facility);
  }

  void upvoteFacility(String facilityId) {
    // In-memory upvote
  }
}
