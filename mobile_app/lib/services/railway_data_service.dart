import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import '../models/station.dart';
import '../models/train.dart';

class RailwayDataService {
  static final RailwayDataService _instance = RailwayDataService._internal();
  factory RailwayDataService() => _instance;
  RailwayDataService._internal();

  List<Station> _stations = [];
  List<Train> _trains = [];
  List<List<LatLng>> _trackSegments = [];
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  List<Station> get stations => List.unmodifiable(_stations);
  List<Train> get trains => List.unmodifiable(_trains);
  List<List<LatLng>> get trackSegments => List.unmodifiable(_trackSegments);

  /// Initialize and load all datasets from asset bundle
  Future<void> init() async {
    if (_isLoaded) return;

    try {
      // 1. Load Stations
      final stationsStr = await rootBundle.loadString('assets/data/stations.json');
      final List<dynamic> stationsJson = json.decode(stationsStr);
      _stations = stationsJson.map((e) => Station.fromJson(e)).toList();

      // 2. Load Trains
      final trainsStr = await rootBundle.loadString('assets/data/trains.json');
      final List<dynamic> trainsJson = json.decode(trainsStr);
      _trains = trainsJson.map((e) => Train.fromJson(e)).toList();

      // 3. Load Railway Track Segments (Edges)
      final edgesStr = await rootBundle.loadString('assets/data/railway_edges.json');
      final List<dynamic> edgesJson = json.decode(edgesStr);
      _trackSegments = [];

      for (var edge in edgesJson) {
        final startLatLon = (edge['startCodeLatLon'] as String? ?? '').split(',');
        final endLatLon = (edge['endCodeLatLon'] as String? ?? '').split(',');
        if (startLatLon.length == 2 && endLatLon.length == 2) {
          final sLat = double.tryParse(startLatLon[0].trim());
          final sLng = double.tryParse(startLatLon[1].trim());
          final eLat = double.tryParse(endLatLon[0].trim());
          final eLng = double.tryParse(endLatLon[1].trim());

          if (sLat != null && sLng != null && eLat != null && eLng != null) {
            _trackSegments.add([
              LatLng(sLat, sLng),
              LatLng(eLat, eLng),
            ]);
          }
        }
      }

      _isLoaded = true;
    } catch (e) {
      // Fallback in case of assets loading issues
      _isLoaded = true;
    }
  }

  /// Search stations by query (Bengali or English)
  List<Station> searchStations(String query) {
    if (query.trim().isEmpty) return _stations;
    return _stations.where((s) => s.matches(query)).toList();
  }

  /// Find trains between selected origin and destination
  List<Train> findTrainsBetween({
    required Station from,
    required Station to,
  }) {
    final fromName = from.name.toLowerCase();
    final toName = to.name.toLowerCase();

    return _trains.where((train) {
      final origin = train.origin.toLowerCase();
      final destination = train.destination.toLowerCase();

      // Direct match or connecting route
      return (origin.contains(fromName) || fromName.contains(origin)) &&
          (destination.contains(toName) || toName.contains(destination));
    }).toList();
  }
}
