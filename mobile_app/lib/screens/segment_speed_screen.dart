import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';

class SegmentSpeedScreen extends StatelessWidget {
  const SegmentSpeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("সেগমেন্ট স্পিড ম্যাপ"),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(23.8500, 90.5000),
              initialZoom: 9.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.bdtraintracker.app',
              ),
              PolylineLayer(
                polylines: [
                  // Fast Segment (> 75 km/h) - Green
                  Polyline(
                    points: const [
                      LatLng(23.7258, 90.4262), // Dhaka
                      LatLng(23.8530, 90.4070), // Airport
                      LatLng(23.9000, 90.4000), // Tongi
                    ],
                    strokeWidth: 5.0,
                    color: AppTheme.onTimeGreen,
                  ),
                  // Medium Speed Segment (50-75 km/h) - Amber
                  Polyline(
                    points: const [
                      LatLng(23.9000, 90.4000), // Tongi
                      LatLng(23.9800, 90.5500), // Ghorashal
                      LatLng(24.0500, 90.7200), // Narsingdi
                    ],
                    strokeWidth: 5.0,
                    color: AppTheme.accentAmber,
                  ),
                  // Bridge / Slow Zone (< 45 km/h) - Red
                  Polyline(
                    points: const [
                      LatLng(24.0500, 90.7200),
                      LatLng(24.0550, 90.7300), // Meghna bridge slow zone
                    ],
                    strokeWidth: 6.0,
                    color: AppTheme.lateRed,
                  ),
                ],
              ),
            ],
          ),

          // Speed Legend Card
          Positioned(
            bottom: 20,
            left: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "রেলওয়ে ট্র্যাক গতিসীমা নির্দেশিকা",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem(AppTheme.onTimeGreen, "দ্রুত (>৭৫ কিমি)"),
                      _buildLegendItem(AppTheme.accentAmber, "মাঝারি (৫০-৭৫)"),
                      _buildLegendItem(AppTheme.lateRed, "ধীর (<৪৫ কিমি)"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.slateText)),
      ],
    );
  }
}
