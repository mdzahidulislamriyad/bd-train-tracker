import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../models/station.dart';
import '../models/train.dart';
import '../models/live_location.dart';
import '../models/stoppage_info.dart';
import '../models/platform_coach_item.dart';
import '../models/station_board_item.dart';
import '../models/prayer_time_model.dart';
import '../services/railway_data_service.dart';

class TrainProvider extends ChangeNotifier {
  final RailwayDataService _dataService = RailwayDataService();

  Station? _fromStation;
  Station? _toStation;
  DateTime _travelDate = DateTime.now();
  List<Train> _allTrains = [];
  List<Train> _searchResults = [];
  bool _isLoading = false;

  // Selected train for details / live tracking
  Train? _selectedTrain;

  // Settings & Toggles
  bool _showPrayerTimes = true;
  PrayerTimeModel _prayerTimes = PrayerTimeModel.getTodayPrayerTimes();

  // Live Tracking state
  bool _isOnTrainTracking = false;
  LiveLocation? _currentLiveLocation;

  Station? get fromStation => _fromStation;
  Station? get toStation => _toStation;
  DateTime get travelDate => _travelDate;
  List<Train> get allTrains => _allTrains;
  List<Train> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isOnTrainTracking => _isOnTrainTracking;
  LiveLocation? get currentLiveLocation => _currentLiveLocation;
  Train? get selectedTrain => _selectedTrain ?? (_allTrains.isNotEmpty ? _allTrains.first : null);
  bool get showPrayerTimes => _showPrayerTimes;
  PrayerTimeModel get prayerTimes => _prayerTimes;

  RailwayDataService get dataService => _dataService;

  /// Setup initial default stations (Dhaka -> Chattogram) and realistic seed trains
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await _dataService.init();

    if (_dataService.stations.isNotEmpty) {
      _fromStation = _dataService.stations.firstWhere(
        (s) => s.name.toLowerCase() == 'dhaka' || s.nameBn == 'ঢাকা',
        orElse: () => _dataService.stations[0],
      );

      _toStation = _dataService.stations.firstWhere(
        (s) => s.name.toLowerCase().contains('chattogram') || s.name.toLowerCase().contains('chittagong') || s.nameBn.contains('চট্টগ্রাম'),
        orElse: () => _dataService.stations.length > 1 ? _dataService.stations[1] : _dataService.stations[0],
      );

      _generateComprehensiveTrains();
      searchTrains();
    }

    _isLoading = false;
    notifyListeners();
  }

  void togglePrayerTimes() {
    _showPrayerTimes = !_showPrayerTimes;
    notifyListeners();
  }

  void selectTrain(Train train) {
    _selectedTrain = train;
    notifyListeners();
  }

  void toggleFavorite(String trainCode) {
    _allTrains = _allTrains.map((t) {
      if (t.code == trainCode) {
        return t.copyWith(isFavorite: !t.isFavorite);
      }
      return t;
    }).toList();

    _searchResults = _searchResults.map((t) {
      if (t.code == trainCode) {
        return t.copyWith(isFavorite: !t.isFavorite);
      }
      return t;
    }).toList();

    notifyListeners();
  }

  void setFromStation(Station station) {
    _fromStation = station;
    searchTrains();
  }

  void setToStation(Station station) {
    _toStation = station;
    searchTrains();
  }

  void swapStations() {
    final temp = _fromStation;
    _fromStation = _toStation;
    _toStation = temp;
    searchTrains();
  }

  void setTravelDate(DateTime date) {
    _travelDate = date;
    notifyListeners();
  }

  void searchTrains() {
    if (_fromStation == null || _toStation == null) return;

    _searchResults = _allTrains.where((train) {
      final matchesOrigin = train.origin.toLowerCase().contains(_fromStation!.name.toLowerCase()) ||
          train.originBn.contains(_fromStation!.nameBn);
      final matchesDest = train.destination.toLowerCase().contains(_toStation!.name.toLowerCase()) ||
          train.destinationBn.contains(_toStation!.nameBn);
      return matchesOrigin || matchesDest;
    }).toList();

    if (_searchResults.isEmpty) {
      // Return popular intercity trains as fallback suggestions
      _searchResults = List.from(_allTrains);
    }

    notifyListeners();
  }

  void toggleOnTrainTracking(bool value) {
    _isOnTrainTracking = value;
    if (_isOnTrainTracking) {
      _currentLiveLocation = LiveLocation(
        trainCode: _selectedTrain?.code ?? "788",
        trainName: _selectedTrain?.nameBn ?? "সোনার বাংলা এক্সপ্রেস",
        position: const LatLng(23.7258, 90.4262),
        speedKmh: 72.5,
        nearestStation: "টঙ্গী জংশন",
        nextStation: "ঢাকা বিমানবন্দর",
        lastUpdated: DateTime.now(),
      );
    }
    notifyListeners();
  }

  /// Platform coach position guide generator matching Gatishil
  StationPlatformGuide getPlatformGuide(Train train, String stationName) {
    return StationPlatformGuide(
      stationName: stationName,
      platformName: "প্ল্যাটফর্ম ৩",
      directionDescription: "${train.destinationBn}-এর অভিমুখে ট্রেন ছুটবে",
      footbridgeSegment: 6,
      coaches: const [
        PlatformCoachItem(coachCode: "ইঞ্জিন", coachName: "লোকোমোটিভ", classType: CoachClassType.engine, platformSegmentNumber: 1),
        PlatformCoachItem(coachCode: "পাওয়ার", coachName: "পাওয়ার কার", classType: CoachClassType.powerCar, platformSegmentNumber: 2),
        PlatformCoachItem(coachCode: "ক", coachName: "শোভন চেয়ার", classType: CoachClassType.shovonChair, platformSegmentNumber: 3),
        PlatformCoachItem(coachCode: "খ", coachName: "শোভন চেয়ার", classType: CoachClassType.shovonChair, platformSegmentNumber: 4),
        PlatformCoachItem(coachCode: "গ", coachName: "শোভন চেয়ার", classType: CoachClassType.shovonChair, platformSegmentNumber: 5),
        PlatformCoachItem(coachCode: "ঘ", coachName: "শোভন চেয়ার (সিঁড়ি সংলগ্ন)", classType: CoachClassType.shovonChair, platformSegmentNumber: 6, hasPassengerStanding: true),
        PlatformCoachItem(coachCode: "ঙ", coachName: "শোভন চেয়ার", classType: CoachClassType.shovonChair, platformSegmentNumber: 7),
        PlatformCoachItem(coachCode: "চ", coachName: "শোভন চেয়ার", classType: CoachClassType.shovonChair, platformSegmentNumber: 8),
        PlatformCoachItem(coachCode: "ছ", coachName: "খাবার গাড়ি / গার্ড ভ্যান", classType: CoachClassType.guardVan, platformSegmentNumber: 9),
        PlatformCoachItem(coachCode: "জ", coachName: "স্নিগ্ধা (এসি চেয়ার)", classType: CoachClassType.snigdha, platformSegmentNumber: 10),
        PlatformCoachItem(coachCode: "ঝ", coachName: "স্নিগ্ধা (এসি চেয়ার)", classType: CoachClassType.snigdha, platformSegmentNumber: 11),
        PlatformCoachItem(coachCode: "ঞ", coachName: "এসি বার্থ / কেবিন", classType: CoachClassType.acBerth, platformSegmentNumber: 12),
        PlatformCoachItem(coachCode: "ট", coachName: "এসি কেবিন", classType: CoachClassType.acCabin, platformSegmentNumber: 13),
      ],
    );
  }

  /// Station Live Digital Display Board generator
  List<StationBoardItem> getStationLiveBoards(String stationName) {
    return [
      StationBoardItem(
        trainNumber: "788",
        trainName: "সোনার বাংলা এক্সপ্রেস",
        origin: "ঢাকা",
        destination: "চট্টগ্রাম",
        scheduledTime: "০৭:০০ AM",
        expectedTime: "০৭:১৫ AM",
        delayMinutes: 15,
        platform: "PF 3",
        type: BoardTrainType.departure,
        statusDescription: "বোর্ডিং চলছে",
      ),
      StationBoardItem(
        trainNumber: "702",
        trainName: "সুবর্ণ এক্সপ্রেস",
        origin: "চট্টগ্রাম",
        destination: "ঢাকা",
        scheduledTime: "০৭:৩০ AM",
        expectedTime: "০৭:৩০ AM",
        delayMinutes: 0,
        platform: "PF 2",
        type: BoardTrainType.arrival,
        statusDescription: "সময়মতো প্রবেশ করছে",
      ),
      StationBoardItem(
        trainNumber: "726",
        trainName: "সুন্দরবন এক্সপ্রেস",
        origin: "খুলনা",
        destination: "ঢাকা",
        scheduledTime: "০৮:১৫ AM",
        expectedTime: "০৮:৪০ AM",
        delayMinutes: 25,
        platform: "PF 4",
        type: BoardTrainType.arrival,
        statusDescription: "বিলম্বিত",
      ),
      StationBoardItem(
        trainNumber: "774",
        trainName: "কালনী এক্সপ্রেস",
        origin: "ঢাকা",
        destination: "সিলেট",
        scheduledTime: "০৮:৪৫ AM",
        expectedTime: "০৮:৪৫ AM",
        delayMinutes: 0,
        platform: "PF 1",
        type: BoardTrainType.departure,
        statusDescription: "প্ল্যাটফর্মে প্রস্তুত",
      ),
      StationBoardItem(
        trainNumber: "766",
        trainName: "দ্রুতযান এক্সপ্রেস",
        origin: "ঢাকা",
        destination: "পঞ্চগড়",
        scheduledTime: "০৯:০০ AM",
        expectedTime: "০৯:১২ AM",
        delayMinutes: 12,
        platform: "PF 5",
        type: BoardTrainType.departure,
        statusDescription: "বিলম্বিত",
      ),
    ];
  }

  void _generateComprehensiveTrains() {
    _allTrains = [
      Train(
        id: 1,
        code: "788",
        name: "Sonar Bangla Express",
        nameBn: "সোনার বাংলা এক্সপ্রেস",
        origin: "Dhaka",
        originBn: "ঢাকা",
        destination: "Chattogram",
        destinationBn: "চট্টগ্রাম",
        depTime: "07:00",
        arrTime: "12:15",
        offDay: "Tuesday",
        type: "Intercity Non-Stop",
        liveDelayMinutes: 14,
        currentSpeed: 74.0,
        nextStationName: "ঢাকা বিমানবন্দর",
        lastUpdatedTimeAgo: "১ মি আগে",
        activePassengersCount: 28,
        totalVisits: 840,
        journeyCompletedPercent: 32.0,
        completedDistanceKm: 110.0,
        totalDistanceKm: 342.0,
        stoppages: const [
          StoppageInfo(
            stationName: "ঢাকা (কমলাপুর)",
            stationCode: "DA",
            scheduledArrival: "০৬:৪৫ AM",
            scheduledDeparture: "০৭:০০ AM",
            actualArrival: "০৬:৪৫ AM",
            actualDeparture: "০৭:০৫ AM",
            delayMinutes: 5,
            platformNumber: "PF 3",
            distanceKm: 0.0,
            isDeparted: true,
            fares: {'shovon': 405, 'snigdha': 777, 'ac_seat': 932, 'ac_berth': 1398},
            intermediateStations: [
              PassingStation(name: "তেজগাঁও", estimatedTime: "≈ ০৭:০৯ AM", distanceKm: 4.2),
              PassingStation(name: "বনানী", estimatedTime: "≈ ০৭:১৫ AM", distanceKm: 8.5),
            ],
          ),
          StoppageInfo(
            stationName: "ঢাকা বিমানবন্দর",
            stationCode: "DAA",
            scheduledArrival: "০৭:২৩ AM",
            scheduledDeparture: "০৭:২৮ AM",
            actualArrival: "০৭:৩৫ AM",
            actualDeparture: "০৭:৪০ AM",
            delayMinutes: 12,
            platformNumber: "PF 2",
            distanceKm: 14.5,
            isCurrentStation: true,
            fares: {'shovon': 405, 'snigdha': 777, 'ac_seat': 932, 'ac_berth': 1398},
            intermediateStations: [
              PassingStation(name: "টঙ্গী জংশন", estimatedTime: "≈ ০৭:৫২ AM", distanceKm: 22.0),
              PassingStation(name: "পূবাইল", estimatedTime: "≈ ০৮:০২ AM", distanceKm: 31.5),
              PassingStation(name: "ঘোড়াশাল", estimatedTime: "≈ ০৮:১৫ AM", distanceKm: 45.0),
              PassingStation(name: "নরসিংদী", estimatedTime: "≈ ০৮:৩০ AM", distanceKm: 62.0),
              PassingStation(name: "ভৈরব বাজার জংশন", estimatedTime: "≈ ০৮:৫২ AM", distanceKm: 86.0),
            ],
          ),
          StoppageInfo(
            stationName: "চট্টগ্রাম",
            stationCode: "CG",
            scheduledArrival: "১২:১৫ PM",
            scheduledDeparture: "১২:১৫ PM",
            actualArrival: "১২:২৯ PM",
            actualDeparture: "১২:২৯ PM",
            delayMinutes: 14,
            platformNumber: "PF 1",
            distanceKm: 342.0,
            fares: {'shovon': 405, 'snigdha': 777, 'ac_seat': 932, 'ac_berth': 1398},
          ),
        ],
      ),
      Train(
        id: 2,
        code: "702",
        name: "Suborna Express",
        nameBn: "সুবর্ণ এক্সপ্রেস",
        origin: "Dhaka",
        originBn: "ঢাকা",
        destination: "Chattogram",
        destinationBn: "চট্টগ্রাম",
        depTime: "16:30",
        arrTime: "21:50",
        offDay: "Monday",
        type: "Intercity Premier",
        liveDelayMinutes: 0,
        currentSpeed: 78.0,
        nextStationName: "ঢাকা বিমানবন্দর",
        lastUpdatedTimeAgo: "এখনই",
        activePassengersCount: 35,
        totalVisits: 1250,
        journeyCompletedPercent: 12.0,
        completedDistanceKm: 42.0,
        totalDistanceKm: 342.0,
        stoppages: const [
          StoppageInfo(
            stationName: "ঢাকা (কমলাপুর)",
            stationCode: "DA",
            scheduledArrival: "১৬:১৫ PM",
            scheduledDeparture: "১৬:৩০ PM",
            actualArrival: "১৬:১৫ PM",
            actualDeparture: "১৬:৩০ PM",
            delayMinutes: 0,
            platformNumber: "PF 2",
            distanceKm: 0.0,
            isDeparted: true,
            fares: {'shovon': 405, 'snigdha': 777, 'ac_seat': 932, 'ac_berth': 1398},
          ),
          StoppageInfo(
            stationName: "ঢাকা বিমানবন্দর",
            stationCode: "DAA",
            scheduledArrival: "১৬:৫৩ PM",
            scheduledDeparture: "১৬:৫৮ PM",
            actualArrival: "১৬:৫৩ PM",
            actualDeparture: "১৬:৫৮ PM",
            delayMinutes: 0,
            platformNumber: "PF 1",
            distanceKm: 14.5,
            isCurrentStation: true,
            fares: {'shovon': 405, 'snigdha': 777, 'ac_seat': 932, 'ac_berth': 1398},
          ),
          StoppageInfo(
            stationName: "চট্টগ্রাম",
            stationCode: "CG",
            scheduledArrival: "২১:৫০ PM",
            scheduledDeparture: "২১:৫০ PM",
            actualArrival: "২১:৫০ PM",
            actualDeparture: "২১:৫০ PM",
            delayMinutes: 0,
            platformNumber: "PF 3",
            distanceKm: 342.0,
            fares: {'shovon': 405, 'snigdha': 777, 'ac_seat': 932, 'ac_berth': 1398},
          ),
        ],
      ),
      Train(
        id: 3,
        code: "726",
        name: "Sundarban Express",
        nameBn: "সুন্দরবন এক্সপ্রেস",
        origin: "Khulna",
        originBn: "খুলনা",
        destination: "Dhaka",
        destinationBn: "ঢাকা",
        depTime: "22:15",
        arrTime: "05:10",
        offDay: "Tuesday",
        type: "Intercity Express",
        liveDelayMinutes: 25,
        currentSpeed: 62.0,
        nextStationName: "পোড়াদহ জংশন",
        lastUpdatedTimeAgo: "৩ মি আগে",
        activePassengersCount: 19,
        totalVisits: 620,
        journeyCompletedPercent: 64.0,
        completedDistanceKm: 215.0,
        totalDistanceKm: 335.0,
      ),
      Train(
        id: 4,
        code: "774",
        name: "Kalni Express",
        nameBn: "কালনী এক্সপ্রেস",
        origin: "Dhaka",
        originBn: "ঢাকা",
        destination: "Sylhet",
        destinationBn: "সিলেট",
        depTime: "15:00",
        arrTime: "21:30",
        offDay: "Friday",
        type: "Intercity",
        liveDelayMinutes: 8,
        currentSpeed: 65.0,
        nextStationName: "ভৈরব বাজার",
        lastUpdatedTimeAgo: "২ মি আগে",
        activePassengersCount: 22,
        totalVisits: 510,
        journeyCompletedPercent: 40.0,
        completedDistanceKm: 128.0,
        totalDistanceKm: 319.0,
      ),
      Train(
        id: 5,
        code: "766",
        name: "Drutojan Express",
        nameBn: "দ্রুতযান এক্সপ্রেস",
        origin: "Dhaka",
        originBn: "ঢাকা",
        destination: "Panchagarh",
        destinationBn: "পঞ্চগড়",
        depTime: "20:00",
        arrTime: "06:10",
        offDay: "None",
        type: "Intercity Long-haul",
        liveDelayMinutes: 18,
        currentSpeed: 70.0,
        nextStationName: "শান্তাহার জংশন",
        lastUpdatedTimeAgo: "১ মি আগে",
        activePassengersCount: 31,
        totalVisits: 980,
        journeyCompletedPercent: 55.0,
        completedDistanceKm: 270.0,
        totalDistanceKm: 490.0,
      ),
    ];
  }
}
