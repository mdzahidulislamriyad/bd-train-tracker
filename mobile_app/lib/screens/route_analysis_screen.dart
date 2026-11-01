import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/railway_data_service.dart';
import '../theme/app_theme.dart';

class RouteAnalysisScreen extends StatefulWidget {
  const RouteAnalysisScreen({super.key});

  @override
  State<RouteAnalysisScreen> createState() => _RouteAnalysisScreenState();
}

class _RouteAnalysisScreenState extends State<RouteAnalysisScreen> {
  final RailwayDataService _dataService = RailwayDataService();
  int _dayFilterIndex = 2; // 0: ১ দিন, 1: ৭ দিন, 2: ১০ দিন
  int _modeIndex = 0; // 0: গতি, 1: বিলম্ব, 2: আপ লাইন, 3: ডাউন লাইন

  @override
  Widget build(BuildContext context) {
    final trackSegments = _dataService.trackSegments;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Satellite Map with Color-Coded Segments (Matches Screenshot 8)
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(23.8500, 90.4000),
              initialZoom: 7.2,
              minZoom: 6.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.gatishil.bd_train_tracker',
              ),
              // Multi-colored speed segments (orange, blue, pink, purple)
              PolylineLayer(
                polylines: List.generate(trackSegments.length, (i) {
                  final seg = trackSegments[i];
                  final colors = [
                    const Color(0xFFEA580C), // Orange (40 km/h)
                    const Color(0xFF0284C7), // Blue (60 km/h)
                    const Color(0xFFDB2777), // Pink (80 km/h)
                    const Color(0xFF7C3AED), // Purple (80+ km/h)
                  ];
                  return Polyline(
                    points: seg,
                    strokeWidth: 4.0,
                    color: colors[i % colors.length],
                  );
                }),
              ),
            ],
          ),

          // 2. Top Header and Day Filter (Screenshot 8)
          SafeArea(
            child: Column(
              children: [
                // Curved Magenta Header
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppTheme.primary, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "রুট বিশ্লেষণ",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                            ),
                            Text(
                              "গত ১০ দিনের গড়",
                              style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.info_outline, color: AppTheme.textMuted),
                    ],
                  ),
                ),

                // Day Filter Pills: [ ১ দিন ] [ ৭ দিন ] [ ১০ দিন ]
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Row(
                    children: [
                      _buildDayFilterItem(0, "১ দিন"),
                      _buildDayFilterItem(1, "৭ দিন"),
                      _buildDayFilterItem(2, "১০ দিন"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Bottom Controls & Speed Legend Sheet (Screenshot 8)
          Positioned(
            bottom: 16,
            left: 14,
            right: 14,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mode Switches: [ গতি ] [ বিলম্ব ] [ আপ লাইন ] [ ডাউন লাইন ]
                    Row(
                      children: [
                        _buildModeButton(0, "গতি"),
                        const SizedBox(width: 6),
                        _buildModeButton(1, "বিলম্ব"),
                        const SizedBox(width: 6),
                        _buildModeButton(2, "আপ লাইন"),
                        const SizedBox(width: 6),
                        _buildModeButton(3, "ডাউন লাইন"),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Color Gradient Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "গতি (কিমি/ঘ)",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                        Row(
                          children: [
                            Container(width: 12, height: 3, color: const Color(0xFF94A3B8)),
                            const SizedBox(width: 4),
                            const Text("তথ্য নেই", style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Gradient Colors Strip
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Row(
                        children: [
                          Expanded(child: Container(height: 8, color: Colors.black87)),
                          Expanded(child: Container(height: 8, color: const Color(0xFFDC2626))),
                          Expanded(child: Container(height: 8, color: const Color(0xFFEA580C))),
                          Expanded(child: Container(height: 8, color: const Color(0xFF0284C7))),
                          Expanded(child: Container(height: 8, color: const Color(0xFFDB2777))),
                          Expanded(child: Container(height: 8, color: const Color(0xFF7C3AED))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Speed numbers (0, 20, 40, 60, 80, 80+)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("০", style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                        Text("২০", style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                        Text("৪০", style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                        Text("৬০", style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                        Text("৮০", style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                        Text("৮০+", style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Footer: 👆 বিস্তারিত দেখতে যেকোনো অংশে ট্যাপ করুন
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.touch_app_outlined, size: 14, color: AppTheme.textMuted),
                        SizedBox(width: 4),
                        Text(
                          "বিস্তারিত দেখতে যেকোনো অংশে ট্যাপ করুন",
                          style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
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

  Widget _buildDayFilterItem(int index, String label) {
    final isSelected = _dayFilterIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _dayFilterIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFCE4EC) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primary : AppTheme.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(int index, String label) {
    final isSelected = _modeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _modeIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFCE4EC) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primary : AppTheme.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
