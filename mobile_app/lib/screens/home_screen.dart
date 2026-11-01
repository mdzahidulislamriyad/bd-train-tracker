import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/station.dart';
import '../models/train.dart';
import '../providers/train_provider.dart';
import '../theme/app_theme.dart';
import 'live_status_screen.dart';
import 'live_map_screen.dart';
import 'station_board_screen.dart';
import 'coach_position_screen.dart';
import 'route_analysis_screen.dart';
import 'railway_safety_screen.dart';
import 'train_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _searchTabIndex = 0; // 0: ট্রেন, 1: রুট, 2: বলে খুঁজুন

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Curved Magenta Header + Floating Search Card Stack
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Curved Magenta Header
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Subtle Train Overlay Silhouette
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Opacity(
                          opacity: 0.15,
                          child: Image.asset(
                            'assets/images/bg_train_overlay.png',
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const SizedBox(),
                          ),
                        ),
                      ),
                      // Header Content (User Greeting & Actions)
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Md Zahidul Islam",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Pill Button: ★ দেখতে ট্যাপ করুন
                                  InkWell(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("ইউজার প্রোফাইল ও সাবস্ক্রিপশন")),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.08),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.star, color: AppTheme.primary, size: 14),
                                          SizedBox(width: 4),
                                          Text(
                                            "দেখতে ট্যাপ করুন",
                                            style: TextStyle(
                                              color: AppTheme.primary,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Circular White 3-Dot Button
                              Container(
                                width: 38,
                                height: 38,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.more_vert, color: AppTheme.primary, size: 20),
                                  onPressed: () => _showMenuBottomSheet(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Floating Search Card Overlapping the Header
                Padding(
                  padding: const EdgeInsets.only(top: 130, left: 14, right: 14),
                  child: _buildFloatingSearchCard(context, provider),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 2. Primary 8 Circular Feature Icons (2 rows of 4)
            _buildPrimaryFeatureGrid(context, provider),

            const SizedBox(height: 12),

            // 3. Prayer Times & Roza Countdown Card
            _buildPrayerTimesCard(context, provider),

            const SizedBox(height: 14),

            // 4. Rail Safety Banner
            _buildRailSafetyBanner(context),

            const SizedBox(height: 16),

            // 5. "আরও সেবা" Section (8 More Circular Feature Icons)
            _buildMoreServicesSection(context),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  // --- FLOATING SEARCH CARD (Exact Match to Screenshots 1, 2, 3) ---
  Widget _buildFloatingSearchCard(BuildContext context, TrainProvider provider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 3-Tab Switcher: [ 🚆 ট্রেন ] | [ 📍 রুট ] | [ 🎤 বলে খুঁজুন ]
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  _buildSearchTabItem(0, Icons.train_outlined, "ট্রেন"),
                  _buildSearchTabItem(1, Icons.location_on_outlined, "রুট"),
                  _buildSearchTabItem(2, Icons.mic_none_outlined, "বলে খুঁজুন"),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Tab Content
            if (_searchTabIndex == 0)
              _buildTrainSearchContent(context, provider)
            else if (_searchTabIndex == 1)
              _buildRouteSearchContent(context, provider)
            else
              _buildVoiceSearchContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTabItem(int index, IconData icon, String label) {
    final isSelected = _searchTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _searchTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppTheme.primary : AppTheme.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppTheme.primary : AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Content for Tab 1: [ 🚆 ট্রেন ]
  Widget _buildTrainSearchContent(BuildContext context, TrainProvider provider) {
    return Column(
      children: [
        // Dropdown Search Input
        InkWell(
          onTap: () => _openTrainPicker(context, provider),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppTheme.textMuted, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    provider.selectedTrain != null
                        ? "${provider.selectedTrain!.nameBn} (${provider.selectedTrain!.code})"
                        : "নাম বা নম্বর লিখুন — যেমন ৭০১",
                    style: TextStyle(
                      fontSize: 14,
                      color: provider.selectedTrain != null ? AppTheme.textDark : AppTheme.textMuted,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: AppTheme.textMuted),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Big Vibrant Magenta Action Button: [ ট্রেন দেখুন ]
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LiveStatusScreen()),
              );
            },
            child: const Text(
              "ট্রেন দেখুন",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // Content for Tab 2: [ 📍 রুট ] (Matches Screenshot 3)
  Widget _buildRouteSearchContent(BuildContext context, TrainProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            // From Station Box
            Expanded(
              child: InkWell(
                onTap: () => _openStationPicker(context, isFrom: true),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("থেকে", style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: AppTheme.textMuted, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              provider.fromStation?.nameBn ?? "স্টেশন লিখুন",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Circular Swap Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: InkWell(
                onTap: () => provider.swapStations(),
                customBorder: const CircleBorder(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Icon(Icons.swap_horiz, color: AppTheme.primary, size: 20),
                ),
              ),
            ),
            // To Station Box
            Expanded(
              child: InkWell(
                onTap: () => _openStationPicker(context, isFrom: false),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("পর্যন্ত", style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: AppTheme.textMuted, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              provider.toStation?.nameBn ?? "স্টেশন লিখুন",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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

        const SizedBox(height: 8),

        // "+ মাঝে ট্রেন বদল যোগ করুন"
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.add, color: AppTheme.primary, size: 16),
            label: const Text(
              "মাঝে ট্রেন বদল যোগ করুন",
              style: TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("ট্রানজিট / কানেক্টিং ট্রেন অপশন যোগ করা হয়েছে")),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Action Button: [ ট্রেন দেখুন ]
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LiveStatusScreen()),
              );
            },
            child: const Text("ট্রেন দেখুন", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),

        const SizedBox(height: 10),

        // Recent Search History Chips
        Row(
          children: [
            _buildRecentRouteChip(context, provider, "খুলনা ➔ বেনাপোল"),
            const SizedBox(width: 8),
            _buildRecentRouteChip(context, provider, "খুলনা ➔ যশোর"),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentRouteChip(BuildContext context, TrainProvider provider, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, color: AppTheme.primary, size: 13),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textDark)),
        ],
      ),
    );
  }

  // Content for Tab 3: [ 🎤 বলে খুঁজুন ]
  Widget _buildVoiceSearchContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("শুনছি... ট্রেনের নাম বা স্টেশন বলুন")),
              );
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primary, width: 2),
              ),
              child: const Icon(Icons.mic, color: AppTheme.primary, size: 28),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "মাইক্রোফোনে ট্যাপ করে ট্রেনের নাম বলুন",
            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  // --- 8 PRIMARY CIRCULAR FEATURE ICONS (Exact Match to Screenshots 1, 2) ---
  Widget _buildPrimaryFeatureGrid(BuildContext context, TrainProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularFeatureItem(
                label: "ট্রেন লোকেটর",
                icon: Icons.location_on,
                bgColor: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF2E7D32),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveMapScreen())),
              ),
              _buildCircularFeatureItem(
                label: "লাইভ স্ট্যাটাস",
                icon: Icons.directions_subway,
                bgColor: const Color(0xFFE1F5FE),
                iconColor: const Color(0xFF0288D1),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveStatusScreen())),
              ),
              _buildCircularFeatureItem(
                label: "লাইভ চ্যাট",
                icon: Icons.forum,
                bgColor: const Color(0xFFE0F2F1),
                iconColor: const Color(0xFF00897B),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TrainChatScreen(train: provider.selectedTrain ?? provider.allTrains.first)),
                ),
              ),
              _buildCircularFeatureItem(
                label: "স্টেশন বোর্ড",
                icon: Icons.dashboard,
                bgColor: const Color(0xFFFFF3E0),
                iconColor: const Color(0xFFF57C00),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StationBoardScreen())),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularFeatureItem(
                label: "স্টেশন অবস্থা",
                icon: Icons.account_balance,
                bgColor: const Color(0xFFEDE7F6),
                iconColor: const Color(0xFF5E35B1),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StationBoardScreen())),
              ),
              _buildCircularFeatureItem(
                label: "হারানো-পাওয়া",
                icon: Icons.work_outline,
                bgColor: const Color(0xFFE0F7FA),
                iconColor: const Color(0xFF0097A7),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("রেলওয়ে হারানো ও প্রাপ্তি ডেস্ক")),
                  );
                },
              ),
              _buildCircularFeatureItem(
                label: "বগির অবস্থান",
                icon: Icons.view_carousel,
                bgColor: const Color(0xFFE8F8F5),
                iconColor: const Color(0xFF16A085),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CoachPositionScreen())),
              ),
              _buildCircularFeatureItem(
                label: "রুট বিশ্লেষণ",
                icon: Icons.trending_up,
                bgColor: const Color(0xFFE3F2FD),
                iconColor: const Color(0xFF1976D2),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RouteAnalysisScreen())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularFeatureItem({
    required String label,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 72,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- PRAYER TIMES CARD (Exact Match to Screenshot 1) ---
  Widget _buildPrayerTimesCard(BuildContext context, TrainProvider provider) {
    final pt = provider.prayerTimes;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              // 5 Waqt Row with Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWaqtItem("ফজর", pt.fajr, Icons.nightlight_round),
                  _buildWaqtItem("যোহর", pt.dhuhr, Icons.wb_sunny_outlined),
                  _buildWaqtItem("আসর", pt.asr, Icons.wb_sunny),
                  _buildWaqtItem("মাগরিব", pt.maghrib, Icons.wb_twilight),
                  _buildWaqtItem("এশা", pt.isha, Icons.bedtime),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
              ),

              // Date Bar with Arrows: < আজ, ১ নভে • ২০ জমাদিউল আউয়াল 📍 >
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chevron_left, color: AppTheme.textMuted, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    pt.dateString,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textBody),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.location_on, color: AppTheme.textMuted, size: 14),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, color: AppTheme.textMuted, size: 20),
                ],
              ),

              const SizedBox(height: 12),

              // Bottom 2-Column Split (Sehri & Iftar)
              Row(
                children: [
                  // Left Column: Sehri
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("সেহরি শেষ", style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        const SizedBox(height: 2),
                        Text(
                          pt.sehriEnd,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.statusGreen),
                        ),
                        const SizedBox(height: 2),
                        Text("উদয় ${pt.sunrise}", style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        const SizedBox(height: 6),
                        Text(
                          pt.currentWaqt,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.statusGreen),
                        ),
                        Text(
                          pt.timeRemaining,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(height: 70, width: 1, color: const Color(0xFFE2E8F0)),

                  // Right Column: Iftar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("ইফতার", style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        const SizedBox(height: 2),
                        Text(
                          pt.iftarTime,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary),
                        ),
                        const SizedBox(height: 2),
                        Text("অস্ত ${pt.sunset}", style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        const SizedBox(height: 6),
                        const Text(
                          "সেহরি বাকি",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.statusGreen),
                        ),
                        Text(
                          pt.sehriRemaining,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark),
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
    );
  }

  Widget _buildWaqtItem(String name, String time, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppTheme.accentAmber),
        const SizedBox(height: 2),
        Text(name, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
        const SizedBox(height: 2),
        Text(
          time,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textDark),
        ),
      ],
    );
  }

  // --- RAIL SAFETY BANNER (Exact Match to Screenshot 2) ---
  Widget _buildRailSafetyBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RailwaySafetyScreen())),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDCFCE7)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_user_outlined, color: Color(0xFF16A34A), size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "রেল নিরাপত্তা",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF14532D)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "ট্রেন, প্ল্যাটফর্ম ও লাইনে নিরাপদ থাকুন",
                      style: TextStyle(fontSize: 12, color: Color(0xFF15803D)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF16A34A)),
            ],
          ),
        ),
      ),
    );
  }

  // --- "আরও সেবা" SECTION (Exact Match to Screenshot 2) ---
  Widget _buildMoreServicesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "আরও সেবা",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularFeatureItem(
                label: "নির্দেশিকা",
                icon: Icons.menu_book_outlined,
                bgColor: const Color(0xFFE1F5FE),
                iconColor: const Color(0xFF0288D1),
                onTap: () => _showNotice(context, "ব্যবহার নির্দেশিকা ও গাইডলাইন"),
              ),
              _buildCircularFeatureItem(
                label: "প্রশ্নোত্তর",
                icon: Icons.help_outline,
                bgColor: const Color(0xFFE0F2F1),
                iconColor: const Color(0xFF00897B),
                onTap: () => _showNotice(context, "প্রায়শই জিজ্ঞাসিত প্রশ্নোত্তর (FAQ)"),
              ),
              _buildCircularFeatureItem(
                label: "অভিযোগ",
                icon: Icons.campaign_outlined,
                bgColor: const Color(0xFFFFF3E0),
                iconColor: const Color(0xFFF57C00),
                onTap: () => _showNotice(context, "বাংলাদেশ রেলওয়ে হেল্পলাইন ও অভিযোগ"),
              ),
              _buildCircularFeatureItem(
                label: "পরবর্তী ট্রেন",
                icon: Icons.access_time_outlined,
                bgColor: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF2E7D32),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveStatusScreen())),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularFeatureItem(
                label: "আমাদের পণ্য",
                icon: Icons.shopping_bag_outlined,
                bgColor: const Color(0xFFFFF8E1),
                iconColor: const Color(0xFFFFA000),
                onTap: () => _showNotice(context, "রেলওয়ে অফিসিয়াল শপ ও পণ্য"),
              ),
              _buildCircularFeatureItem(
                label: "ট্রেন ব্লগ",
                icon: Icons.edit_note,
                bgColor: const Color(0xFFFCE4EC),
                iconColor: const Color(0xFFD81B60),
                onTap: () => _showNotice(context, "রেল ভ্রমণ গল্প ও ফিচার ব্লগ"),
              ),
              _buildCircularFeatureItem(
                label: "সেটিংস",
                icon: Icons.settings_outlined,
                bgColor: const Color(0xFFECEFF1),
                iconColor: const Color(0xFF546E7A),
                onTap: () => _showNotice(context, "অ্যাপ সেটিংস ও নোটিফিকেশন কনফিগারেশন"),
              ),
              _buildCircularFeatureItem(
                label: "লিডারবোর্ড",
                icon: Icons.emoji_events_outlined,
                bgColor: const Color(0xFFFFFDE7),
                iconColor: const Color(0xFFFBC02D),
                onTap: () => _showNotice(context, "শীর্ষ কন্ট্রিবিউটর লিডারবোর্ড"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNotice(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
  }

  void _openTrainPicker(BuildContext context, TrainProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("ট্রেন নির্বাচন করুন", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.allTrains.length,
                  itemBuilder: (ctx, i) {
                    final t = provider.allTrains[i];
                    return ListTile(
                      title: Text("${t.nameBn} (${t.code})"),
                      subtitle: Text("${t.originBn} ➔ ${t.destinationBn}"),
                      onTap: () {
                        provider.selectTrain(t);
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

  void _openStationPicker(BuildContext context, {required bool isFrom}) {
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
              Text(isFrom ? "প্রারম্ভিক স্টেশন" : "গন্তব্য স্টেশন", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                        if (isFrom) {
                          provider.setFromStation(s);
                        } else {
                          provider.setToStation(s);
                        }
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

  void _showMenuBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.share, color: AppTheme.primary),
                title: const Text("অ্যাপ শেয়ার করুন"),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: const Icon(Icons.star_rate, color: AppTheme.primary),
                title: const Text("রেটিং দিন"),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: AppTheme.primary),
                title: const Text("আমাদের সম্পর্কে"),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }
}
