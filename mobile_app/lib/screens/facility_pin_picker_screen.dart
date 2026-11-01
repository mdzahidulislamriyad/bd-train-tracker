import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/station_facility.dart';
import '../theme/app_theme.dart';

class FacilityPinPickerScreen extends StatefulWidget {
  final LatLng initialCenter;
  final String stationName;
  final List<StationFacility> existingFacilities;
  final bool isPickerMode;

  const FacilityPinPickerScreen({
    super.key,
    required this.initialCenter,
    required this.stationName,
    this.existingFacilities = const [],
    this.isPickerMode = false,
  });

  @override
  State<FacilityPinPickerScreen> createState() => _FacilityPinPickerScreenState();
}

class _FacilityPinPickerScreenState extends State<FacilityPinPickerScreen> {
  final MapController _mapController = MapController();
  late LatLng _selectedPin;
  StationFacility? _selectedFacility;

  @override
  void initState() {
    super.initState();
    _selectedPin = widget.initialCenter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isPickerMode
              ? '${widget.stationName} - পিন নির্ধারণ করুন'
              : '${widget.stationName} - ম্যাপ ভিউ',
        ),
        actions: [
          if (widget.isPickerMode)
            TextButton(
              child: const Text(
                'নিশ্চিত করুন',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context, _selectedPin);
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          // 1. OpenStreetMap Layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialCenter,
              initialZoom: 17.0, // High zoom to see station platforms
              minZoom: 12.0,
              maxZoom: 19.0,
              onTap: (tapPosition, point) {
                if (widget.isPickerMode) {
                  setState(() {
                    _selectedPin = point;
                  });
                } else {
                  setState(() {
                    _selectedFacility = null;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.gatishil.bd_train_tracker',
              ),
              // Markers Layer
              MarkerLayer(
                markers: widget.isPickerMode
                    ? [
                        // Draggable/Tapped Pin for new facility
                        Marker(
                          point: _selectedPin,
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.location_pin,
                            size: 45,
                            color: Colors.red,
                          ),
                        ),
                      ]
                    : widget.existingFacilities.map((f) {
                        return Marker(
                          point: LatLng(f.lat, f.lng),
                          width: 44,
                          height: 44,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFacility = f;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.primaryGreen, width: 2),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26, blurRadius: 6),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  f.category.iconAsset,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
              ),
            ],
          ),

          // 2. Picker Mode Instructions Banner
          if (widget.isPickerMode)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.touch_app, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ম্যাপে নির্দিষ্ট স্থানে ট্যাপ করে পিনটি বসান।',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 3. Facility Detail Card on Map Tap (View Mode)
          if (!widget.isPickerMode && _selectedFacility != null)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _selectedFacility!.category.iconAsset,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedFacility!.titleBn,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _selectedFacility!.platform,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => setState(() => _selectedFacility = null),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedFacility!.locationHint,
                        style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
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
