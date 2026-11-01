import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';

class CoachPositionScreen extends StatefulWidget {
  const CoachPositionScreen({super.key});

  @override
  State<CoachPositionScreen> createState() => _CoachPositionScreenState();
}

class _CoachPositionScreenState extends State<CoachPositionScreen> {
  String _selectedCoach = "খ";
  final List<String> _coaches = ["ক", "খ", "গ", "ঘ", "ঙ", "চ"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // 1. Curved Magenta Header (Matches Screenshot 9)
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 16, left: 16, right: 16),
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                // Back Button
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_back, color: AppTheme.primary, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "বেতনা কমিউটার",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "খুলনা থেকে উঠবেন ⇄",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.layers, color: AppTheme.primary, size: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Card 1: Your Coach Badge and Details (Screenshot 9)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Big Mustard Circle Badge with Bengali letter
                              Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFB45309), // Mustard
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _selectedCoach,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "আপনার বগি • খ",
                                      style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                    ),
                                    const Text(
                                      "সামনের দিক থেকে ২ নম্বর",
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Icon(Icons.verified_outlined, color: AppTheme.statusGreen, size: 14),
                                        const SizedBox(width: 4),
                                        const Text(
                                          "মোটামুটি নির্ভরযোগ্য • ১ ঘণ্টা আগে",
                                          style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  minimumSize: const Size(50, 32),
                                ),
                                onPressed: () {},
                                child: const Text("বদলান", style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                          const Divider(height: 24, color: Color(0xFFF1F5F9)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("যাত্রীদের চিহ্নিত তথ্য থেকে", style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                              Row(
                                children: [
                                  const Icon(Icons.flag_outlined, size: 14, color: AppTheme.textMuted),
                                  const SizedBox(width: 4),
                                  const Text("রিপোর্ট", style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Card 2: Platform & Satellite Coach Position Map (Screenshot 9)
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Platform Header Strip
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE0F2FE),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.directions_train, size: 14, color: Color(0xFF0284C7)),
                                        SizedBox(width: 4),
                                        Text(
                                          "প্ল্যাটফর্ম ৪",
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text("পরিবর্তন", style: TextStyle(fontSize: 11, color: AppTheme.primary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Notice: ⓘ আপনার প্ল্যাটফর্ম নাও হতে পারে — পরিবর্তন করতে ট্যাপ করুন
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.info_outline, size: 14, color: Color(0xFFD97706)),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    "আপনার প্ল্যাটফর্ম নাও হতে পারে — পরিবর্তন করতে ট্যাপ করুন",
                                    style: TextStyle(fontSize: 11, color: Color(0xFF92400E)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Satellite Map Container with Train Graphic
                        SizedBox(
                          height: 220,
                          child: Stack(
                            children: [
                              FlutterMap(
                                options: const MapOptions(
                                  initialCenter: LatLng(22.8252, 89.5542), // Khulna Railway Station
                                  initialZoom: 16.5,
                                  minZoom: 14.0,
                                  maxZoom: 19.0,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                                    userAgentPackageName: 'com.gatishil.bd_train_tracker',
                                  ),
                                  // Coach Marker Layer
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: const LatLng(22.8252, 89.5542),
                                        width: 44,
                                        height: 44,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                                            border: Border.all(color: const Color(0xFFB45309), width: 2),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _selectedCoach,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFB45309),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. Coach Sequence (বগির ক্রম: সামনে ➔ পিছনে) (Screenshot 9)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "বগির ক্রম",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                      ),
                      const Text(
                        "সামনে ➔ পিছনে",
                        style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Engine Icon
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF334155),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.directions_train, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 8),
                        ..._coaches.map((c) {
                          final isSelected = c == _selectedCoach;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedCoach = c),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFB45309) : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFB45309) : const Color(0xFFE2E8F0),
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    c,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : AppTheme.textDark,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sticky Bottom Notice: [ 🔒 আপনি এই ট্রেনে থাকলে যোগ করতে পারবেন ]
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, color: AppTheme.textMuted, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "আপনি এই ট্রেনে থাকলে যোগ করতে পারবেন",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
