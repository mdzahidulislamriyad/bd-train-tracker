import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import '../models/station.dart';
import '../models/train.dart';
import '../models/stoppage_info.dart';
import '../models/prayer_time_model.dart';

class TrainProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Station> _allStations = [];
  List<Station> get allStations => _allStations;

  List<Train> _allTrains = [];
  List<Train> get allTrains => _allTrains;

  Station? _fromStation;
  Station? get fromStation => _fromStation;

  Station? _toStation;
  Station? get toStation => _toStation;

  Train? _selectedTrain;
  Train? get selectedTrain => _selectedTrain;

  PrayerTimeModel _prayerTimes = PrayerTimeModel.seed();
  PrayerTimeModel get prayerTimes => _prayerTimes;

  int _userPoints = 350;
  int get userPoints => _userPoints;

  String _userTier = "গোল্ড ট্রাভেলার টিয়ার";
  String get userTier => _userTier;

  // Selected coach letter in Coach Position Screen
  String _selectedCoachLetter = "খ";
  String get selectedCoachLetter => _selectedCoachLetter;

  // Selected station in Station Board Screen
  String _selectedBoardStation = "ঢাকা";
  String get selectedBoardStation => _selectedBoardStation;

  void initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadStations();
      _loadSeedTrains();
    } catch (e) {
      debugPrint("Error initializing train data: $e");
      _loadSeedStations();
      _loadSeedTrains();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadStations() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/stations.json');
      final List<dynamic> list = jsonDecode(jsonStr);
      _allStations = list.map((e) => Station.fromJson(e)).toList();
      if (_allStations.isNotEmpty) {
        _fromStation = _allStations.firstWhere((s) => s.nameBn == "খুলনা", orElse: () => _allStations.first);
        _toStation = _allStations.firstWhere((s) => s.nameBn == "বেনাপোল", orElse: () => _allStations[1]);
      }
    } catch (_) {
      _loadSeedStations();
    }
  }

  void _loadSeedStations() {
    _allStations = const [
      Station(id: 1, code: "DA", name: "Dhaka", nameBn: "ঢাকা", lat: 23.7315, lng: 90.4267),
      Station(id: 2, code: "CG", name: "Chattogram", nameBn: "চট্টগ্রাম", lat: 22.3355, lng: 91.8315),
      Station(id: 3, code: "SY", name: "Sylhet", nameBn: "সিলেট", lat: 24.8872, lng: 91.8687),
      Station(id: 4, code: "KL", name: "Khulna", nameBn: "খুলনা", lat: 22.8252, lng: 89.5542),
      Station(id: 5, code: "RJ", name: "Rajshahi", nameBn: "রাজশাহী", lat: 24.3745, lng: 88.6042),
      Station(id: 6, code: "AIR", name: "Biman Bandar", nameBn: "বিমানবন্দর", lat: 23.8516, lng: 90.4078),
      Station(id: 7, code: "BNP", name: "Benapole", nameBn: "বেনাপোল", lat: 23.0416, lng: 88.8967),
      Station(id: 8, code: "JSR", name: "Jashore", nameBn: "যশোর", lat: 23.1678, lng: 89.2139),
      Station(id: 9, code: "TNG", name: "Tangail", nameBn: "টাঙ্গাইল", lat: 24.2513, lng: 89.9167),
      Station(id: 10, code: "FEN", name: "Feni", nameBn: "ফেনী", lat: 23.0159, lng: 91.3976),
    ];
    _fromStation = _allStations[3]; // খুলনা
    _toStation = _allStations[6]; // বেনাপোল
  }

  void _loadSeedTrains() {
    _allTrains = [
      Train(
        id: 773,
        code: "773",
        name: "Kalni Express",
        nameBn: "কালনী এক্সপ্রেস",
        origin: "Dhaka",
        originBn: "ঢাকা",
        destination: "Sylhet",
        destinationBn: "সিলেট",
        depTime: "02:55 PM",
        arrTime: "09:30 PM",
        offDay: "Friday",
        type: "Intercity",
        liveDelayMinutes: 5,
        currentSpeed: 74.0,
        journeyCompletedPercent: 92.0,
        nextStationName: "শমসেরনগর",
        stoppages: _getSampleStoppages("কালনী এক্সপ্রেস"),
      ),
      Train(
        id: 710,
        code: "710",
        name: "Parabat Express",
        nameBn: "পারাবত এক্সপ্রেস",
        origin: "Sylhet",
        originBn: "সিলেট",
        destination: "Dhaka",
        destinationBn: "ঢাকা",
        depTime: "04:00 PM",
        arrTime: "10:40 PM",
        offDay: "Monday",
        type: "Intercity",
        liveDelayMinutes: 0,
        currentSpeed: 68.0,
        journeyCompletedPercent: 84.0,
        nextStationName: "শ্রীমঙ্গল",
        stoppages: _getSampleStoppages("পারাবত এক্সপ্রেস"),
      ),
      Train(
        id: 787,
        code: "787",
        name: "Sonar Bangla Express",
        nameBn: "সোনার বাংলা এক্সপ্রেস",
        origin: "Chattogram",
        originBn: "চট্টগ্রাম",
        destination: "Dhaka",
        destinationBn: "ঢাকা",
        depTime: "05:00 PM",
        arrTime: "09:55 PM",
        offDay: "Tuesday",
        type: "Intercity",
        liveDelayMinutes: 40,
        currentSpeed: 82.0,
        journeyCompletedPercent: 94.0,
        nextStationName: "ঢাকা বিমানবন্দর",
        stoppages: _getSampleStoppages("সোনার বাংলা এক্সপ্রেস"),
      ),
      Train(
        id: 51,
        code: "51",
        name: "Jamalpur Commuter",
        nameBn: "জামালপুর কমিউটার",
        origin: "Dhaka",
        originBn: "ঢাকা",
        destination: "Dewanganj Bazar",
        destinationBn: "দেওয়ানগঞ্জ বাজার",
        depTime: "03:40 PM",
        arrTime: "10:20 PM",
        offDay: "None",
        type: "Commuter",
        liveDelayMinutes: 12,
        currentSpeed: 55.0,
        journeyCompletedPercent: 82.0,
        nextStationName: "গফরগাঁও",
      ),
      Train(
        id: 784,
        code: "784",
        name: "Tungipara Express",
        nameBn: "টুঙ্গীপাড়া এক্সপ্রেস",
        origin: "Rajshahi",
        originBn: "রাজশাহী",
        destination: "Gobra",
        destinationBn: "গোবরা",
        depTime: "03:30 PM",
        arrTime: "10:10 PM",
        offDay: "Monday",
        type: "Intercity",
        liveDelayMinutes: 15,
        currentSpeed: 64.0,
        journeyCompletedPercent: 91.0,
        nextStationName: "পোড়াদহ",
      ),
      Train(
        id: 734,
        code: "734",
        name: "Titumir Express",
        nameBn: "তিতুমীর এক্সপ্রেস",
        origin: "Chilahati",
        originBn: "চিলাহাটি",
        destination: "Rajshahi",
        destinationBn: "রাজশাহী",
        depTime: "03:00 PM",
        arrTime: "09:30 PM",
        offDay: "Wednesday",
        type: "Intercity",
        liveDelayMinutes: 8,
        currentSpeed: 70.0,
        journeyCompletedPercent: 88.0,
        nextStationName: "সান্তাহার",
      ),
      Train(
        id: 723,
        code: "723",
        name: "Udayan Express",
        nameBn: "উদয়ন এক্সপ্রেস",
        origin: "Chattogram",
        originBn: "চট্টগ্রাম",
        destination: "Sylhet",
        destinationBn: "সিলেট",
        depTime: "09:45 PM",
        arrTime: "05:45 AM",
        offDay: "Thursday",
        type: "Intercity",
        liveDelayMinutes: 0,
        currentSpeed: 62.0,
        journeyCompletedPercent: 2.0,
        nextStationName: "ফেনী",
      ),
      Train(
        id: 755,
        code: "755",
        name: "Madhumati Express",
        nameBn: "মধুমতি এক্সপ্রেস",
        origin: "Dhaka",
        originBn: "ঢাকা",
        destination: "Rajshahi",
        destinationBn: "রাজশাহী",
        depTime: "03:00 PM",
        arrTime: "10:30 PM",
        offDay: "Saturday",
        type: "Intercity",
        liveDelayMinutes: 20,
        currentSpeed: 75.0,
        journeyCompletedPercent: 77.0,
        nextStationName: "ঈশ্বরদী",
      ),
      Train(
        id: 760,
        code: "760",
        name: "Padma Express",
        nameBn: "পদ্মা এক্সপ্রেস",
        origin: "Rajshahi",
        originBn: "রাজশাহী",
        destination: "Dhaka",
        destinationBn: "ঢাকা",
        depTime: "04:00 PM",
        arrTime: "09:15 PM",
        offDay: "Tuesday",
        type: "Intercity",
        liveDelayMinutes: 18,
        currentSpeed: 78.0,
        journeyCompletedPercent: 93.0,
        nextStationName: "জয়দেবপুর",
      ),
      Train(
        id: 743,
        code: "743",
        name: "Brahmaputra Express",
        nameBn: "ব্রহ্মপুত্র এক্সপ্রেস",
        origin: "Dhaka",
        originBn: "ঢাকা",
        destination: "Dewanganj Bazar",
        destinationBn: "দেওয়ানগঞ্জ বাজার",
        depTime: "06:15 PM",
        arrTime: "11:50 PM",
        offDay: "None",
        type: "Intercity",
        liveDelayMinutes: 10,
        currentSpeed: 66.0,
        journeyCompletedPercent: 54.0,
        nextStationName: "ময়মনসিংহ",
      ),
      Train(
        id: 757,
        code: "757",
        name: "Drutojan Express",
        nameBn: "দ্রুতযান এক্সপ্রেস",
        origin: "Dhaka",
        originBn: "ঢাকা",
        destination: "Panchagarh",
        destinationBn: "পঞ্চগড়",
        depTime: "08:45 PM",
        arrTime: "07:10 AM",
        offDay: "None",
        type: "Intercity",
        liveDelayMinutes: 4,
        currentSpeed: 72.0,
        journeyCompletedPercent: 9.0,
        nextStationName: "ঢাকা বিমানবন্দর",
      ),
      Train(
        id: 794,
        code: "794",
        name: "Panchagarh Express",
        nameBn: "পঞ্চগড় এক্সপ্রেস",
        origin: "Panchagarh",
        originBn: "পঞ্চগড়",
        destination: "Dhaka",
        destinationBn: "ঢাকা",
        depTime: "12:10 PM",
        arrTime: "10:10 PM",
        offDay: "None",
        type: "Intercity",
        liveDelayMinutes: 0,
        currentSpeed: 76.0,
        journeyCompletedPercent: 83.0,
        nextStationName: "জয়দেবপুর",
      ),
      Train(
        id: 95,
        code: "95",
        name: "Betna Commuter",
        nameBn: "বেতনা কমিউটার",
        origin: "Khulna",
        originBn: "খুলনা",
        destination: "Benapole",
        destinationBn: "বেনাপোল",
        depTime: "06:15 AM",
        arrTime: "08:30 AM",
        offDay: "None",
        type: "Commuter",
        liveDelayMinutes: 0,
        currentSpeed: 48.0,
        journeyCompletedPercent: 60.0,
        nextStationName: "যশোর",
      ),
    ];
    _selectedTrain = _allTrains[2]; // সোনার বাংলা
  }

  List<StoppageInfo> _getSampleStoppages(String trainName) {
    return const [
      StoppageInfo(
        stationName: "চট্টগ্রাম",
        stationCode: "CG",
        scheduledArrival: "০৪:৪৫ PM",
        scheduledDeparture: "০৫:০০ PM",
        actualArrival: "০৪:৪৫ PM",
        actualDeparture: "০৫:০০ PM",
        delayMinutes: 0,
        platformNumber: "PF 1",
        isDeparted: true,
      ),
      StoppageInfo(
        stationName: "ফেনী জংশন",
        stationCode: "FEN",
        scheduledArrival: "০৬:০৫ PM",
        scheduledDeparture: "০৬:১০ PM",
        actualArrival: "০৬:১০ PM",
        actualDeparture: "০৬:১৫ PM",
        delayMinutes: 5,
        platformNumber: "PF 2",
        isDeparted: true,
      ),
      StoppageInfo(
        stationName: "ঢাকা বিমানবন্দর",
        stationCode: "AIR",
        scheduledArrival: "০৯:২০ PM",
        scheduledDeparture: "০৯:২৫ PM",
        actualArrival: "১০:০০ PM",
        actualDeparture: "১০:০৫ PM",
        delayMinutes: 40,
        platformNumber: "PF 1",
        isCurrentStation: true,
      ),
      StoppageInfo(
        stationName: "ঢাকা (কমলাপুর)",
        stationCode: "DA",
        scheduledArrival: "০৯:৫৫ PM",
        scheduledDeparture: "--",
        actualArrival: "১০:৩৫ PM",
        actualDeparture: "--",
        delayMinutes: 40,
        platformNumber: "PF 7",
      ),
    ];
  }

  void setFromStation(Station s) {
    _fromStation = s;
    notifyListeners();
  }

  void setToStation(Station s) {
    _toStation = s;
    notifyListeners();
  }

  void swapStations() {
    final temp = _fromStation;
    _fromStation = _toStation;
    _toStation = temp;
    notifyListeners();
  }

  void selectTrain(Train t) {
    _selectedTrain = t;
    notifyListeners();
  }

  void selectCoachLetter(String letter) {
    _selectedCoachLetter = letter;
    notifyListeners();
  }

  void setBoardStation(String stationName) {
    _selectedBoardStation = stationName;
    notifyListeners();
  }
}
