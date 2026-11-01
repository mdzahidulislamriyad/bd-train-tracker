import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../models/station.dart';
import '../models/train.dart';
import '../models/live_location.dart';
import '../services/railway_data_service.dart';

class TrainProvider extends ChangeNotifier {
  final RailwayDataService _dataService = RailwayDataService();

  Station? _fromStation;
  Station? _toStation;
  DateTime _travelDate = DateTime.now();
  List<Train> _searchResults = [];
  bool _isLoading = false;

  // Live Tracking state
  bool _isOnTrainTracking = false;
  LiveLocation? _currentLiveLocation;

  Station? get fromStation => _fromStation;
  Station? get toStation => _toStation;
  DateTime get travelDate => _travelDate;
  List<Train> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isOnTrainTracking => _isOnTrainTracking;
  LiveLocation? get currentLiveLocation => _currentLiveLocation;

  /// Setup initial default stations (Dhaka -> Chattogram)
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await _dataService.init();

    if (_dataService.stations.isNotEmpty) {
      _fromStation = _dataService.stations.firstWhere(
        (s) => s.name.toLowerCase() == 'dhaka',
        orElse: () => _dataService.stations[0],
      );

      _toStation = _dataService.stations.firstWhere(
        (s) => s.name.toLowerCase().contains('chattogram') || s.name.toLowerCase().contains('chittagong'),
        orElse: () => _dataService.stations.length > 1 ? _dataService.stations[1] : _dataService.stations[0],
      );

      searchTrains();
    }

    _isLoading = false;
    notifyListeners();
  }

  void setFromStation(Station station) {
    _fromStation = station;
    notifyListeners();
  }

  void setToStation(Station station) {
    _toStation = station;
    notifyListeners();
  }

  void setTravelDate(DateTime date) {
    _travelDate = date;
    notifyListeners();
  }

  /// Swap Origin and Destination
  void swapStations() {
    final temp = _fromStation;
    _fromStation = _toStation;
    _toStation = temp;
    searchTrains();
    notifyListeners();
  }

  /// Search trains matching current selection
  void searchTrains() {
    if (_fromStation == null || _toStation == null) {
      _searchResults = [];
      return;
    }

    _searchResults = _dataService.findTrainsBetween(
      from: _fromStation!,
      to: _toStation!,
    );
    notifyListeners();
  }

  /// Toggle "I am on train" live crowdsourced GPS sharing
  void toggleOnTrainTracking(Train train) {
    _isOnTrainTracking = !_isOnTrainTracking;

    if (_isOnTrainTracking) {
      // Create initial simulated/live location anchored on origin station
      final startPos = _fromStation != null
          ? LatLng(_fromStation!.lat, _fromStation!.lng)
          : const LatLng(23.7260, 90.4208);

      _currentLiveLocation = LiveLocation(
        trainCode: train.code,
        trainName: train.nameBn,
        position: startPos,
        speedKmh: 68.5,
        nearestStation: _fromStation?.nameBn ?? 'কমলাপুর',
        nextStation: 'বিমানবন্দর',
        lastUpdated: DateTime.now(),
        activePassengers: 12,
        isLive: true,
      );
    } else {
      _currentLiveLocation = null;
    }

    notifyListeners();
  }
}
