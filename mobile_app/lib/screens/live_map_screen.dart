import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/train.dart';
import '../providers/train_provider.dart';
import '../services/railway_data_service.dart';
import '../theme/app_theme.dart';
import 'live_status_detail_screen.dart';

class LiveMapScreen extends StatefulWidget {
  final Train? train;

  const LiveMapScreen({super.key, this.train});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final MapController _mapController = MapController();
  final RailwayDataService _dataService = RailwayDataService();
  final TextEditingController _searchController = TextEditingController();

  Train? _highlightedTrain;
  bool _isSatellite = false;

  final List<Map<String, dynamic>> _liveTrainPins = [
    {"code": "706", "lat": 25.80, "lng": 88.85, "color": const Color(0xFFF97316)}, // Orange
    {"code": "766", "lat": 25.20, "lng": 89.20, "color": const Color(0xFFDB2777)}, // Pink
    {"code": "714", "lat": 25.10, "lng": 89.50, "color": const Color(0xFFDC2626)}, // Red
    {"code": "51", "lat": 24.50, "lng": 89.90, "color": const Color(0xFF0284C7)}, // Blue
    {"code": "743", "lat": 24.40, "lng": 90.10, "color": const Color(0xFF0284C7)},
    {"code": "773", "lat": 24.30, "lng": 91.60, "color": const Color(0xFF0284C7)},
    {"code": "794", "lat": 24.10, "lng": 90.00, "color": const Color(0xFFDB2777)},
    {"code": "44", "lat": 23.95, "lng": 90.30, "color": const Color(0xFFF59E0B)}, // Amber
    {"code": "703", "lat": 23.85, "lng": 90.41, "color": const Color(0xFF334155)}, // Dark
    {"code": "135", "lat": 23.60, "lng": 90.20, "color": const Color(0xFF7C3AED)}, // Purple
    {"code": "729", "lat": 23.45, "lng": 90.70, "color": const Color(0xFFEA580C)},
    {"code": "720", "lat": 23.35, "lng": 91.10, "color": const Color(0xFF475569)},
    {"code": "802", "lat": 23.10, "lng": 91.35, "color": const Color(0xFF0284C7)},
    {"code": "815", "lat": 22.40, "lng": 91.80, "color": const Color(0xFFF59E0B)},
    {"code": "824", "lat": 21.80, "lng": 92.10, "color": const Color(0xFFDB2777)},
  ];

  @override
  void initState() {
    super.initState();
    _highlightedTrain = widget.train;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainProvider>();
    final activeTrain = _highlightedTrain ?? widget.train ?? provider.selectedTrain ?? provider.allTrains.first;
    final trackSegments = _dataService.trackSegments;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Interactive Map (OpenStreetMap with Satellite/Streets toggle)
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(23.8500, 90.4000),
              initialZoom: 7.5,
              minZoom: 6.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: _isSatellite
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.gatishil.bd_train_tracker',
              ),
              // Railway Tracks Polylines
              PolylineLayer(
                polylines: trackSegments.map((seg) {
                  return Polyline(
                    points: seg,
                    strokeWidth: 3.0,
                    color: _isSatellite ? Colors.white70 : Colors.black87,
                  );
                }).toList(),
              ),
              // Train Markers Layer (Matches Screenshot 5)
              MarkerLayer(
                markers: _liveTrainPins.map((pin) {
                  final code = pin["code"] as String;
                  final color = pin["color"] as Color;
                  final lat = pin["lat"] as double;
                  final lng = pin["lng"] as double;

                  return Marker(
                    point: LatLng(lat, lng),
                    width: 38,
                    height: 38,
                    child: GestureDetector(
                      onTap: () {
                        final matched = provider.allTrains.firstWhere(
                          (t) => t.code == code,
                          orElse: () => activeTrain,
                        );
                        setState(() => _highlightedTrain = matched);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                        child: Center(
                          child: Text(
                            code,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // 2. Top Header and Search Bar (Matches Screenshot 5)
          SafeArea(
            child: Column(
              children: [
                // Top Search Bar: [ 🔍 ট্রেন কোড দিয়ে খুঁজুন ] + [ খুঁজুন ] button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppTheme.primary, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: "ট্রেন কোড দিয়ে খুঁজুন",
                              hintStyle: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            final code = _searchController.text.trim();
                            if (code.isNotEmpty) {
                              final match = _liveTrainPins.firstWhere(
                                (p) => p["code"] == code,
                                orElse: () => _liveTrainPins.first,
                              );
                              _mapController.move(LatLng(match["lat"] as double, match["lng"] as double), 11.0);
                            }
                          },
                          child: const Text("খুঁজুন", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Map Layer Toggle Button (Right Side)
          Positioned(
            top: 90,
            right: 14,
            child: GestureDetector(
              onTap: () => setState(() => _isSatellite = !_isSatellite),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Column(
                  children: [
                    Icon(
                      _isSatellite ? Icons.layers : Icons.satellite_alt,
                      color: AppTheme.primary,
                      size: 24,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _isSatellite ? "মানচিত্র" : "স্যাটেলাইট",
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Bottom Legend: [ 🟠🟡🔵🟣 গতির রং ]
          Positioned(
            bottom: _highlightedTrain != null ? 140 : 20,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, color: Color(0xFFF97316), size: 10),
                  SizedBox(width: 3),
                  Icon(Icons.circle, color: Color(0xFFF59E0B), size: 10),
                  SizedBox(width: 3),
                  Icon(Icons.circle, color: Color(0xFF0284C7), size: 10),
                  SizedBox(width: 3),
                  Icon(Icons.circle, color: Color(0xFF7C3AED), size: 10),
                  SizedBox(width: 6),
                  Text(
                    "গতির রং",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                  ),
                ],
              ),
            ),
          ),

          // 5. Active Train Floating Card (Bottom)
          if (_highlightedTrain != null)
            Positioned(
              bottom: 16,
              left: 14,
              right: 14,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LiveStatusDetailScreen(train: activeTrain)),
                  );
                },
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppTheme.primarySoft,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.train, color: AppTheme.primary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${activeTrain.nameBn} (${activeTrain.code})",
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "নিকটতম স্টেশন: ${activeTrain.nextStationName}",
                                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: activeTrain.liveDelayMinutes == 0 ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            activeTrain.liveDelayMinutes == 0 ? "অন-টাইম" : "${activeTrain.liveDelayMinutes} মি দেরি",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: activeTrain.liveDelayMinutes == 0 ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
