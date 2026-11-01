import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/train_provider.dart';
import '../theme/app_theme.dart';

class StationBoardScreen extends StatefulWidget {
  const StationBoardScreen({super.key});

  @override
  State<StationBoardScreen> createState() => _StationBoardScreenState();
}

class _StationBoardScreenState extends State<StationBoardScreen> {
  int _boardTabIndex = 0; // 0: ট্রেনের অবস্থা, 1: বোর্ডের ছবি
  String _currentStation = "ঢাকা";

  final List<Map<String, dynamic>> _liveBoardTrains = [
    {
      "time": "২২:৩৫",
      "delayText": "৪০ মি দেরি",
      "delayColor": AppTheme.statusRed,
      "trainName": "সোনার বাংলা এক্সপ্রেস",
      "trainCode": "৭৮৭",
      "route": "চট্টগ্রাম - ঢাকা",
      "platform": "প্ল্যাটফর্ম ৭",
      "schedule": "২১:৫৫",
      "isUpcoming": true,
    },
    {
      "time": "২২:০০",
      "delayText": "ঘোষণা হয়েছে",
      "delayColor": AppTheme.accentBlue,
      "trainName": "উপবন এক্সপ্রেস",
      "trainCode": "৭৩৯",
      "route": "ঢাকা - সিলেট",
      "platform": "প্ল্যাটফর্ম ১",
      "schedule": "২২:০০",
      "isUpcoming": true,
    },
    {
      "time": "২১:৫৪",
      "delayText": "পৌঁছেছে",
      "delayColor": AppTheme.textMuted,
      "trainName": "পঞ্চগড় এক্সপ্রেস",
      "trainCode": "৭৯৪",
      "route": "পঞ্চগড় - ঢাকা",
      "platform": "প্ল্যাটফর্ম ৫",
      "schedule": "২২:১০",
      "isUpcoming": false,
    },
    {
      "time": "২২:১৫",
      "delayText": "সময়মতো",
      "delayColor": AppTheme.statusGreen,
      "trainName": "হাওর এক্সপ্রেস",
      "trainCode": "৭৭৭",
      "route": "ঢাকা - মোহনগঞ্জ",
      "platform": "প্ল্যাটফর্ম ৩",
      "schedule": "২২:১৫",
      "isUpcoming": true,
    },
  ];

  final List<Map<String, String>> _allStationsBoardList = [
    {"name": "চট্টগ্রাম", "trains": "৩টি ট্রেন ৩১মি আগে আপডেট হয়েছে"},
    {"name": "ঢাকা", "trains": "৪টি ট্রেন ৪১মি আগে আপডেট হয়েছে"},
    {"name": "বিমান বন্দর", "trains": "৭টি ট্রেন ১ঘ ২০মি আগে আপডেট হয়েছে"},
    {"name": "টাঙ্গাইল", "trains": "১টি ট্রেন ১ঘ ৫২মি আগে আপডেট হয়েছে"},
    {"name": "ফেনী", "trains": "১৩টি ট্রেন ১ নভেম্বর ২০২৬ তারিখে যোগ..."},
    {"name": "দিনাজপুর", "trains": "১৪টি ট্রেন ১ নভেম্বর ২০২৬ তারিখে যোগ..."},
    {"name": "বাদিয়াখালী", "trains": "৫টি ট্রেন আপডেট হয়েছে"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // 1. Curved Magenta Header (Matches Screenshot 6)
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
                      "স্টেশন বোর্ড",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "ট্রেনের অবস্থা ও বোর্ডের ছবি",
                      style: TextStyle(color: Colors.white70, fontSize: 11),
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
                    icon: const Icon(Icons.grid_view, color: AppTheme.primary, size: 20),
                    onPressed: () => _openStationPicker(context),
                  ),
                ),
              ],
            ),
          ),

          // 2. Station Selector Card (Matches Screenshot 6)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: InkWell(
              onTap: () => _openStationPicker(context),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppTheme.textMuted, size: 20),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("স্টেশন", style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        Text(
                          _currentStation,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_down, color: AppTheme.textMuted),
                  ],
                ),
              ),
            ),
          ),

          // 3. Tab Bar: [ 🚆 ট্রেনের অবস্থা ] | [ 📷 বোর্ডের ছবি ]
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _boardTabIndex = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _boardTabIndex == 0 ? const Color(0xFFFCE4EC) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.train_outlined,
                              size: 16,
                              color: _boardTabIndex == 0 ? AppTheme.primary : AppTheme.textMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "ট্রেনের অবস্থা",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: _boardTabIndex == 0 ? FontWeight.bold : FontWeight.w500,
                                color: _boardTabIndex == 0 ? AppTheme.primary : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _boardTabIndex = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _boardTabIndex == 1 ? const Color(0xFFFCE4EC) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 16,
                              color: _boardTabIndex == 1 ? AppTheme.primary : AppTheme.textMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "বোর্ডের ছবি",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: _boardTabIndex == 1 ? FontWeight.bold : FontWeight.w500,
                                color: _boardTabIndex == 1 ? AppTheme.primary : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: _boardTabIndex == 0 ? _buildTrainBoardList(context) : _buildBoardPhotosList(context),
          ),
        ],
      ),
    );
  }

  // View 1: Live Trains on Station (Screenshot 6)
  Widget _buildTrainBoardList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        // Subheader: গত ১ ঘণ্টা ও আগামী ১ ঘণ্টা • এইমাত্র আপডেট ↺
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "গত ১ ঘণ্টা ও আগামী ১ ঘণ্টা",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                ),
                Text("এইমাত্র আপডেট", style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: AppTheme.primary),
              onPressed: () {},
            ),
          ],
        ),

        const SizedBox(height: 8),

        ..._liveBoardTrains.map((item) {
          final isDelay = item["delayColor"] == AppTheme.statusRed;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time and Delay Pill
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["time"] as String,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDelay ? AppTheme.statusRed : AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (item["delayColor"] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item["delayText"] as String,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: item["delayColor"] as Color,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  // Train Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              item["trainName"] as String,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE4EC),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item["trainCode"] as String,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item["route"] as String,
                          style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item["platform"] as String,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "সূচি ${item["schedule"]}",
                              style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Action Button: [ জানান ]
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      side: const BorderSide(color: AppTheme.primary),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: const Size(50, 30),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${item["trainName"]} এর লাইভ তথ্য সাবমিট করুন")),
                      );
                    },
                    child: const Text("জানান", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // View 2: All Station Boards with Photos (Screenshot 7)
  Widget _buildBoardPhotosList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "৯৫টি স্টেশন",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textMuted),
            ),
            Row(
              children: [
                _buildFilterTag("সব", true),
                const SizedBox(width: 6),
                _buildFilterTag("আজকের", false),
                const SizedBox(width: 6),
                _buildFilterTag("সময়সূচি", false),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._allStationsBoardList.map((st) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Board Photo Placeholder / Image
                  Container(
                    width: 70,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.live_tv, color: Colors.greenAccent, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          st["name"]!,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            const Text("আজকের বোর্ড", style: TextStyle(fontSize: 11, color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          st["trains"]!,
                          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.more_vert, color: AppTheme.textMuted),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFilterTag(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFCE4EC) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? AppTheme.primary : const Color(0xFFE2E8F0)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppTheme.primary : AppTheme.textDark,
        ),
      ),
    );
  }

  void _openStationPicker(BuildContext context) {
    final provider = context.read<TrainProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("স্টেশন নির্বাচন করুন", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.allStations.length,
                  itemBuilder: (ctx, i) {
                    final s = provider.allStations[i];
                    return ListTile(
                      title: Text(s.nameBn),
                      subtitle: Text(s.name),
                      onTap: () {
                        setState(() => _currentStation = s.nameBn);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
