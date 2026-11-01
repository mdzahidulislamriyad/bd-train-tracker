import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/train.dart';
import '../models/stoppage_info.dart';
import '../providers/train_provider.dart';
import '../theme/app_theme.dart';
import 'live_map_screen.dart';
import 'train_chat_screen.dart';
import 'platform_coach_guide_screen.dart';
import 'coach_seat_facing_screen.dart';

class LiveStatusDetailScreen extends StatefulWidget {
  final Train train;

  const LiveStatusDetailScreen({super.key, required this.train});

  @override
  State<LiveStatusDetailScreen> createState() => _LiveStatusDetailScreenState();
}

class _LiveStatusDetailScreenState extends State<LiveStatusDetailScreen> {
  bool _isRefreshing = false;
  final Set<int> _expandedStoppages = {};

  void _refreshLiveStatus() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("লাইভ অবস্থান আপডেট করা হয়েছে"),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainProvider>();
    final train = provider.allTrains.firstWhere(
      (t) => t.code == widget.train.code,
      orElse: () => widget.train,
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${train.nameBn} (${train.code})",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(Icons.visibility_outlined, size: 12, color: Colors.white70),
                const SizedBox(width: 4),
                Text(
                  "${train.activePassengersCount} জন দেখছেন · ${train.totalVisits} ভিজিট",
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              train.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: train.isFavorite ? Colors.redAccent : Colors.white,
            ),
            tooltip: "প্রিয় তালিকায় পিন করুন",
            onPressed: () => provider.toggleFavorite(train.code),
          ),
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.refresh),
            tooltip: "অবস্থান রিফ্রেশ করুন",
            onPressed: _refreshLiveStatus,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (val) {
              if (val == "coach") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PlatformCoachGuideScreen(train: train)),
                );
              } else if (val == "seat") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CoachSeatFacingScreen(train: train)),
                );
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: "coach",
                child: Row(
                  children: [
                    Icon(Icons.directions_railway, color: AppTheme.primary, size: 18),
                    SizedBox(width: 10),
                    Text("প্ল্যাটফর্মে বগির অবস্থান"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "seat",
                child: Row(
                  children: [
                    Icon(Icons.airline_seat_recline_extra, color: AppTheme.primary, size: 18),
                    SizedBox(width: 10),
                    Text("আসন বিন্যাস ও অভিমুখ"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Gatishil 3-Line Signature Floating Live Card
            _buildThreeLineLiveCard(train),

            // 2. Fast Navigation Floating Circular Buttons Row
            _buildFloatingActionRow(train),

            // 3. Journey Progress & 7-Day Delay Chart Card
            _buildJourneyProgressAndStats(train),

            // 4. Stoppage Timeline Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "যাত্রার সময়সূচি ও স্টপেজ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "ছুটি: ${train.offDayBn}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                    ),
                  ),
                ],
              ),
            ),

            // 5. Stoppage Timeline List with Passing Stations & Platforms
            _buildStoppageTimeline(train),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomCrowdsourceBar(train, provider),
    );
  }

  Widget _buildThreeLineLiveCard(Train train) {
    return Container(
      margin: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: AppTheme.primary.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          // Top Bar: Delay status & Last updated time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: train.isOnTime ? AppTheme.primaryLight : const Color(0xFFFEE2E2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      train.isOnTime ? Icons.check_circle : Icons.warning_amber_rounded,
                      size: 16,
                      color: train.isOnTime ? AppTheme.onTimeGreen : AppTheme.lateRed,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      train.delayStatusText,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: train.isOnTime ? AppTheme.onTimeGreen : AppTheme.lateRed,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${train.lastUpdatedTimeAgo} আপডেট",
                  style: const TextStyle(fontSize: 12, color: AppTheme.slateMuted),
                ),
              ],
            ),
          ),

          // Main Middle Info: Next Stoppage Station
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.near_me, color: AppTheme.primary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "পরবর্তী স্টেশন",
                        style: TextStyle(fontSize: 12, color: AppTheme.slateMuted),
                      ),
                      Text(
                        train.nextStationName.isNotEmpty ? train.nextStationName : train.destinationBn,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Bottom 3rd Line: Speedometer & Distance
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.speed, size: 16, color: AppTheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      "${train.currentSpeed.toStringAsFixed(0)} কিমি/ঘ গতি",
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.slateMuted),
                    const SizedBox(width: 4),
                    Text(
                      "${train.originBn} থেকে ${train.completedDistanceKm.toStringAsFixed(0)} কিমি পার",
                      style: const TextStyle(fontSize: 12, color: AppTheme.slateMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionRow(Train train) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: _buildActionCard(
              icon: Icons.map_outlined,
              label: "লাইভ ম্যাপ",
              color: AppTheme.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LiveMapScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildActionCard(
              icon: Icons.forum_outlined,
              label: "বগি চ্যাট",
              color: const Color(0xFF0284C7),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TrainChatScreen(train: train)),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildActionCard(
              icon: Icons.view_column_outlined,
              label: "বগির পজিশন",
              color: AppTheme.accentAmber,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PlatformCoachGuideScreen(train: train)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyProgressAndStats(Train train) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "যাত্রার অগ্রগতি",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
              ),
              Text(
                "${train.journeyCompletedPercent.toStringAsFixed(0)}% সম্পন্ন",
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: train.journeyCompletedPercent / 100.0,
              backgroundColor: AppTheme.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${train.originBn} (${train.depTime})",
                style: const TextStyle(fontSize: 12, color: AppTheme.slateMuted),
              ),
              Text(
                "${train.destinationBn} (${train.arrTime})",
                style: const TextStyle(fontSize: 12, color: AppTheme.slateMuted),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 10),
          // Delay Stats Row
          Row(
            children: [
              const Icon(Icons.insights, size: 18, color: AppTheme.accentAmber),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "এই ট্রেনটি সাধারণত গড়ে ${train.liveDelayMinutes} মিনিট দেরিতে চলে। গত ৭ দিনের অন-টাইম রেকর্ড ৮৬%।",
                  style: const TextStyle(fontSize: 12, color: AppTheme.slateText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoppageTimeline(Train train) {
    if (train.stoppages.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Text(
            "স্টপেজের বিস্তারিত সময়সূচি লোড হচ্ছে...",
            style: TextStyle(color: AppTheme.slateMuted),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: train.stoppages.length,
      itemBuilder: (ctx, index) {
        final stop = train.stoppages[index];
        final isFirst = index == 0;
        final isLast = index == train.stoppages.length - 1;
        final isExpanded = _expandedStoppages.contains(index);

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: stop.isCurrentStation ? AppTheme.primaryLight : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: stop.isCurrentStation ? AppTheme.primary : AppTheme.dividerColor,
                  width: stop.isCurrentStation ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Time Column
                      SizedBox(
                        width: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stop.scheduledDeparture,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                            ),
                            Text(
                              stop.actualDeparture,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: stop.isOnTime ? AppTheme.onTimeGreen : AppTheme.lateRed,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Node Indicator
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: stop.isDeparted
                              ? AppTheme.primary
                              : (stop.isCurrentStation ? AppTheme.accentAmber : Colors.white),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.primary, width: 2.5),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Station Info & Platform Badge
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    stop.stationName,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: stop.isCurrentStation ? FontWeight.bold : FontWeight.w600,
                                      color: AppTheme.slateDark,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: AppTheme.dividerColor),
                                  ),
                                  child: Text(
                                    stop.platformNumber,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                                  ),
                                ),
                              ],
                            ),
                            if (stop.delayMinutes > 0)
                              Text(
                                "${stop.delayMinutes} মি দেরি",
                                style: const TextStyle(fontSize: 11, color: AppTheme.lateRed, fontWeight: FontWeight.w600),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Intermediate / Passing Stations toggle
                  if (stop.intermediateStations.isNotEmpty)
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedStoppages.remove(index);
                          } else {
                            _expandedStoppages.add(index);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, left: 82),
                        child: Row(
                          children: [
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              size: 16,
                              color: AppTheme.slateMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isExpanded
                                  ? "মাঝের স্টেশনগুলো লুকান"
                                  : "না থেমে পার হওয়া ${stop.intermediateStations.length}টি স্টেশন দেখুন",
                              style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Expanded Passing Stations
                  if (isExpanded && stop.intermediateStations.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 82, top: 6),
                      child: Column(
                        children: stop.intermediateStations.map((passing) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.slateMuted,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      passing.name,
                                      style: const TextStyle(fontSize: 12, color: AppTheme.slateText),
                                    ),
                                  ],
                                ),
                                Text(
                                  passing.estimatedTime,
                                  style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomCrowdsourceBar(Train train, TrainProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "আমি এই ট্রেনে আছি",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                  ),
                  Text(
                    provider.isOnTrainTracking ? "🟢 অবস্থান শেয়ার চালু রয়েছে" : "লোকেশন শেয়ার করে পয়েন্ট অর্জন করুন",
                    style: TextStyle(
                      fontSize: 11,
                      color: provider.isOnTrainTracking ? AppTheme.onTimeGreen : AppTheme.slateMuted,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                provider.toggleOnTrainTracking(!provider.isOnTrainTracking);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      provider.isOnTrainTracking
                          ? "ধন্যবাদ! আপনার জিপিএস অবস্থান সবার সাথে শেয়ার হচ্ছে।"
                          : "লোকেশন শেয়ার বন্ধ করা হয়েছে।",
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: provider.isOnTrainTracking ? AppTheme.lateRed : AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Text(
                provider.isOnTrainTracking ? "শেয়ার বন্ধ করুন" : "লোকেশন দিন",
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
