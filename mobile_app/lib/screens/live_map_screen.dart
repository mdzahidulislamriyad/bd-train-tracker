import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/train.dart';
import '../providers/train_provider.dart';
import '../services/railway_data_service.dart';
import '../theme/app_theme.dart';

class LiveMapScreen extends StatefulWidget {
  final Train train;

  const LiveMapScreen({super.key, required this.train});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final MapController _mapController = MapController();
  final RailwayDataService _dataService = RailwayDataService();

  late LatLng _trainPosition;
  late double _speed;
  late String _nearestStation;

  @override
  void initState() {
    super.initState();
    final provider = context.read<TrainProvider>();

    if (provider.isOnTrainTracking &&
        provider.currentLiveLocation?.trainCode == widget.train.code) {
      _trainPosition = provider.currentLiveLocation!.position;
      _speed = provider.currentLiveLocation!.speedKmh;
      _nearestStation = provider.currentLiveLocation!.nearestStation;
    } else {
      // Approximate midpoint on Bangladesh Railway network
      _trainPosition = const LatLng(23.8500, 90.4000);
      _speed = 64.0;
      _nearestStation = 'বিমানবন্দর স্টেশন';
    }
  }

  @override
  Widget build(BuildContext context) {
    final trackSegments = _dataService.trackSegments;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.train.nameBn),
            Text(
              '${widget.train.originBn} ➔ ${widget.train.destinationBn}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'ট্রেন খুঁজুন',
            onPressed: () {
              _mapController.move(_trainPosition, 13.0);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _trainPosition,
              initialZoom: 11.5,
              minZoom: 6.0,
              maxZoom: 18.0,
            ),
            children: [
              // Free OpenStreetMap Tile Layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.gatishil.bd_train_tracker',
              ),
              // Real Bangladesh Railway Tracks (Polylines)
              PolylineLayer(
                polylines: trackSegments.map((seg) {
                  return Polyline(
                    points: seg,
                    strokeWidth: 3.5,
                    color: Colors.black87,
                  );
                }).toList(),
              ),
              // Markers Layer: Train Position & Stations
              MarkerLayer(
                markers: [
                  // Live Moving Train Marker
                  Marker(
                    point: _trainPosition,
                    width: 60,
                    height: 60,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentOrange,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.directions_subway,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 2. Speed Badge Overlay (Top Left)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.speed, color: AppTheme.primaryGreen, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '${_speed.toStringAsFixed(0)} কিমি/ঘণ্টা',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Live Status Bottom Sheet
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppTheme.lightGreen,
                          child: Icon(Icons.train, color: AppTheme.primaryGreen),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.train.nameBn} (${widget.train.code})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'নিকটতম স্টেশন: $_nearestStation',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.fiber_manual_record, color: Colors.green, size: 10),
                              SizedBox(width: 4),
                              Text(
                                'অন-টাইম',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
