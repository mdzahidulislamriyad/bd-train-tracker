import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/station_board_item.dart';
import '../providers/train_provider.dart';
import '../theme/app_theme.dart';

class StationBoardScreen extends StatefulWidget {
  const StationBoardScreen({super.key});

  @override
  State<StationBoardScreen> createState() => _StationBoardScreenState();
}

class _StationBoardScreenState extends State<StationBoardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedStation = "ঢাকা (কমলাপুর)";

  final List<String> _popularStations = [
    "ঢাকা (কমলাপুর)",
    "ঢাকা বিমানবন্দর",
    "চট্টগ্রাম",
    "সিলেট",
    "রাজশাহী",
    "খুলনা",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainProvider>();
    final allBoards = provider.getStationLiveBoards(_selectedStation);
    final departures = allBoards.where((b) => b.type == BoardTrainType.departure).toList();
    final arrivals = allBoards.where((b) => b.type == BoardTrainType.arrival).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("স্টেশন ডিজিটাল ডিসপ্লে বোর্ড"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: "প্রস্থান (Departures)", icon: Icon(Icons.flight_takeoff, size: 18)),
            Tab(text: "আগমন (Arrivals)", icon: Icon(Icons.flight_land, size: 18)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Station Selector Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                const Icon(Icons.train, color: AppTheme.primary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedStation,
                      isExpanded: true,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                      items: _popularStations.map((s) {
                        return DropdownMenuItem(value: s, child: Text(s));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedStation = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Digital Display Notice
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF0F172A),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.live_tv, color: AppTheme.accentGold, size: 14),
                    SizedBox(width: 6),
                    Text(
                      "লাইভ স্টেশন ডিসপ্লে",
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  "স্বয়ংক্রিয় আপডেট",
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBoardList(departures),
                _buildBoardList(arrivals),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardList(List<StationBoardItem> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          "এই মুহূর্তে কোনো ট্রেনের সূচি নেই",
          style: TextStyle(color: AppTheme.slateMuted),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        final item = items[index];
        final isOnTime = item.isOnTime;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.dividerColor),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Platform Badge
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Text(
                        item.platform,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Train Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${item.trainName} (${item.trainNumber})",
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.type == BoardTrainType.departure
                              ? "গন্তব্য: ${item.destination}"
                              : "যাত্রা শুরু: ${item.origin}",
                          style: const TextStyle(fontSize: 12, color: AppTheme.slateMuted),
                        ),
                      ],
                    ),
                  ),

                  // Time and Status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.expectedTime,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isOnTime ? AppTheme.slateDark : AppTheme.lateRed,
                        ),
                      ),
                      if (!isOnTime)
                        Text(
                          "নির্ধারিত: ${item.scheduledTime}",
                          style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted, decoration: TextDecoration.lineThrough),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isOnTime ? AppTheme.primaryLight : const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.statusDescription,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isOnTime ? AppTheme.onTimeGreen : AppTheme.lateRed,
                      ),
                    ),
                  ),
                  if (item.delayMinutes > 0)
                    Text(
                      "${item.delayMinutes} মিনিট দেরিতে",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.lateRed),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
