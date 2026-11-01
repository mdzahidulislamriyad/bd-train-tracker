import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/station.dart';
import '../models/train.dart';
import '../providers/train_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/station_picker_sheet.dart';
import '../widgets/voice_search_sheet.dart';
import 'live_status_detail_screen.dart';
import 'train_schedule_screen.dart';
import 'platform_coach_guide_screen.dart';
import 'coach_seat_facing_screen.dart';
import 'station_board_screen.dart';
import 'train_chat_screen.dart';
import 'station_facilities_screen.dart';
import 'lost_found_screen.dart';
import 'segment_speed_screen.dart';
import 'journey_3d_screen.dart';
import 'railway_shop_screen.dart';
import 'railway_safety_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.train, color: AppTheme.primary, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "বিডি ট্রেন গাইড",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  "বাংলাদেশ রেলওয়ে লাইভ ট্র্যাকিং",
                  style: TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              provider.showPrayerTimes ? Icons.mosque : Icons.mosque_outlined,
              color: provider.showPrayerTimes ? AppTheme.accentGold : Colors.white70,
            ),
            tooltip: "নামাজের সময়সূচি",
            onPressed: () => provider.togglePrayerTimes(),
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.white),
            tooltip: "ভয়েস সার্চ",
            onPressed: () => _openVoiceSearch(context),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => provider.initialize(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Prayer Times Live Card (Toggleable)
                    if (provider.showPrayerTimes) _buildPrayerTimesCard(context, provider),

                    // 2. Main Journey Route Search Card
                    _buildRouteSearchCard(context, provider),

                    // 3. Quick Feature Access Grid (12 Feature Cards)
                    _buildFeatureGridHeader(context),
                    _buildQuickFeatureGrid(context, provider),

                    // 4. Shop & Offers Banner Strip
                    _buildShopPromoStrip(context),

                    // 5. Popular Running Trains Header & List
                    _buildRunningTrainsSection(context, provider),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPrayerTimesCard(BuildContext context, TrainProvider provider) {
    final pt = provider.prayerTimes;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF115E59)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0F766E).withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.mosque, color: AppTheme.accentGold, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    pt.dateString,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "পরবর্তী: ${pt.nextWaqtName} (${pt.timeRemaining})",
                  style: const TextStyle(color: AppTheme.accentGold, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWaqtBadge("ফজর", pt.fajr),
              _buildWaqtBadge("যোহর", pt.dhuhr),
              _buildWaqtBadge("আসর", pt.asr),
              _buildWaqtBadge("মাগরিব", pt.maghrib),
              _buildWaqtBadge("এশা", pt.isha),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaqtBadge(String name, String time) {
    return Column(
      children: [
        Text(name, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 2),
        Text(time, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRouteSearchCard(BuildContext context, TrainProvider provider) {
    final dateFormat = DateFormat('EEE, d MMMM yyyy', 'bn');

    return Card(
      margin: const EdgeInsets.all(14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // From Station Row
            InkWell(
              onTap: () => _openStationPicker(context, isFrom: true),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.trip_origin, color: AppTheme.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("কোথা থেকে", style: TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
                          Text(
                            provider.fromStation?.nameBn ?? "স্টেশন নির্বাচন করুন",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: AppTheme.slateMuted),
                  ],
                ),
              ),
            ),

            // Swap Button
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: IconButton(
                  icon: const Icon(Icons.swap_vert, color: AppTheme.primary, size: 26),
                  onPressed: () => provider.swapStations(),
                  tooltip: "স্টেশন অদল-বদল",
                ),
              ),
            ),

            // To Station Row
            InkWell(
              onTap: () => _openStationPicker(context, isFrom: false),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppTheme.accentAmber, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("কোথায় যাবেন", style: TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
                          Text(
                            provider.toStation?.nameBn ?? "স্টেশন নির্বাচন করুন",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: AppTheme.slateMuted),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Date Picker Row
            InkWell(
              onTap: () => _pickDate(context, provider),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.dividerColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18, color: AppTheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        dateFormat.format(provider.travelDate),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.slateDark),
                      ),
                    ),
                    const Icon(Icons.edit_calendar, size: 18, color: AppTheme.slateMuted),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Search Trains Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => provider.searchTrains(),
                icon: const Icon(Icons.search, size: 20),
                label: const Text("ট্রেন খুঁজুন", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGridHeader(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "দ্রুত ফিচার অ্যাক্সেস",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
          ),
          Text(
            "১২টি সেবা",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFeatureGrid(BuildContext context, TrainProvider provider) {
    final activeTrain = provider.selectedTrain;

    final List<Map<String, dynamic>> features = [
      {
        "icon": Icons.near_me,
        "title": "ট্রেন লোকেটর",
        "color": const Color(0xFF0D5C3A),
        "onTap": () {
          if (activeTrain != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => LiveStatusDetailScreen(train: activeTrain)));
          }
        },
      },
      {
        "icon": Icons.schedule,
        "title": "সময়সূচি ও রুট",
        "color": const Color(0xFF0284C7),
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => TrainScheduleScreen(initialTrain: activeTrain)));
        },
      },
      {
        "icon": Icons.view_column_outlined,
        "title": "বগির অবস্থান",
        "color": const Color(0xFFD97706),
        "onTap": () {
          if (activeTrain != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => PlatformCoachGuideScreen(train: activeTrain)));
          }
        },
      },
      {
        "icon": Icons.event_seat_outlined,
        "title": "আসন ও অভিমুখ",
        "color": const Color(0xFF16A34A),
        "onTap": () {
          if (activeTrain != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CoachSeatFacingScreen(train: activeTrain)));
          }
        },
      },
      {
        "icon": Icons.live_tv_outlined,
        "title": "ডিজিটাল বোর্ড",
        "color": const Color(0xFF7C3AED),
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StationBoardScreen()));
        },
      },
      {
        "icon": Icons.forum_outlined,
        "title": "বগি চ্যাট",
        "color": const Color(0xFF059669),
        "onTap": () {
          if (activeTrain != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => TrainChatScreen(train: activeTrain)));
          }
        },
      },
      {
        "icon": Icons.pin_drop_outlined,
        "title": "স্টেশন সুবিধা",
        "color": const Color(0xFFDC2626),
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StationFacilitiesScreen()));
        },
      },
      {
        "icon": Icons.find_in_page_outlined,
        "title": "হারানো-প্রাপ্তি",
        "color": const Color(0xFFEA580C),
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const LostFoundScreen()));
        },
      },
      {
        "icon": Icons.speed,
        "title": "স্পিড ম্যাপ",
        "color": const Color(0xFF4F46E5),
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SegmentSpeedScreen()));
        },
      },
      {
        "icon": Icons.view_in_ar,
        "title": "৩ডি জার্নি",
        "color": const Color(0xFF2563EB),
        "onTap": () {
          if (activeTrain != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => Journey3DScreen(train: activeTrain)));
          }
        },
      },
      {
        "icon": Icons.storefront_outlined,
        "title": "রেলওয়ে শপ",
        "color": const Color(0xFFDB2777),
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const RailwayShopScreen()));
        },
      },
      {
        "icon": Icons.security,
        "title": "নিরাপত্তা ও হেল্প",
        "color": const Color(0xFF475569),
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const RailwaySafetyScreen()));
        },
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 6,
          childAspectRatio: 0.85,
        ),
        itemCount: features.length,
        itemBuilder: (ctx, i) {
          final f = features[i];
          final color = f['color'] as Color;

          return InkWell(
            onTap: f['onTap'] as VoidCallback,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(f['icon'] as IconData, color: color, size: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  f['title'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.slateDark),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShopPromoStrip(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, color: AppTheme.accentAmber, size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "বাংলাদেশ রেলওয়ে অফিশিয়াল শপ ও মার্চেন্ডাইজ",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                ),
                Text(
                  "টি-শার্ট, লোকোমোটিভ কি-রিং ও ট্রাভেল কিট ঘুরে দেখুন।",
                  style: TextStyle(fontSize: 11, color: Color(0xFF78350F)),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RailwayShopScreen()));
            },
            child: const Text("শপ দেখুন", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildRunningTrainsSection(BuildContext context, TrainProvider provider) {
    final trains = provider.searchResults;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "জনপ্রিয় আন্তঃনগর ট্রেনসমূহ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
              ),
              Text(
                "${trains.length}টি ট্রেন",
                style: const TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: trains.length,
          itemBuilder: (ctx, i) {
            final train = trains[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              child: InkWell(
                onTap: () {
                  provider.selectTrain(train);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LiveStatusDetailScreen(train: train)),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                train.nameBn,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  train.code,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primary),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: train.isOnTime ? AppTheme.primaryLight : const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              train.delayStatusText,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: train.isOnTime ? AppTheme.onTimeGreen : AppTheme.lateRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${train.originBn} (${train.depTime})", style: const TextStyle(fontSize: 13, color: AppTheme.slateText)),
                          const Icon(Icons.arrow_right_alt, color: AppTheme.slateMuted),
                          Text("${train.destinationBn} (${train.arrTime})", style: const TextStyle(fontSize: 13, color: AppTheme.slateText)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.speed, size: 14, color: AppTheme.primary),
                              const SizedBox(width: 4),
                              Text(
                                "${train.currentSpeed.toStringAsFixed(0)} কিমি/ঘ",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                              ),
                            ],
                          ),
                          Text(
                            "ছুটি: ${train.offDayBn}",
                            style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _openStationPicker(BuildContext context, {required bool isFrom}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StationPickerSheet(
        title: isFrom ? "যাত্রার প্রারম্ভিক স্টেশন" : "গন্তব্য স্টেশন",
        onSelected: (station) {
          final p = context.read<TrainProvider>();
          if (isFrom) {
            p.setFromStation(station);
          } else {
            p.setToStation(station);
          }
        },
      ),
    );
  }

  void _pickDate(BuildContext context, TrainProvider provider) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.travelDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      provider.setTravelDate(picked);
    }
  }

  void _openVoiceSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => VoiceSearchSheet(
        onRecognized: (query) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("খুঁজছি: $query"), behavior: SnackBarBehavior.floating),
          );
        },
      ),
    );
  }
}
