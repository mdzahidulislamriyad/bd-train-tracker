import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/train.dart';
import '../providers/train_provider.dart';
import '../theme/app_theme.dart';

class TrainScheduleScreen extends StatefulWidget {
  final Train? initialTrain;

  const TrainScheduleScreen({super.key, this.initialTrain});

  @override
  State<TrainScheduleScreen> createState() => _TrainScheduleScreenState();
}

class _TrainScheduleScreenState extends State<TrainScheduleScreen> {
  Train? _selectedTrain;

  @override
  void initState() {
    super.initState();
    _selectedTrain = widget.initialTrain;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainProvider>();
    final trains = provider.allTrains;
    final train = _selectedTrain ?? (trains.isNotEmpty ? trains.first : null);

    if (train == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("ট্রেনের সময়সূচি ও ভাড়া")),
        body: const Center(child: Text("কোনো ট্রেনের তথ্য পাওয়া যায়নি")),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("সময়সূচি ও ভাড়া তালিকা"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Train Selector Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [
                  const Icon(Icons.train, color: AppTheme.primary, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Train>(
                        value: train,
                        isExpanded: true,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                        items: trains.map((t) {
                          return DropdownMenuItem(value: t, child: Text("${t.nameBn} (${t.code})"));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedTrain = val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Route Overview Card
            Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("যাত্রা শুরু", style: TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
                          Text(train.originBn, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.slateDark)),
                          Text(train.depTime, style: const TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(Icons.arrow_forward, color: AppTheme.primary),
                          Text("${train.travelDuration} যাত্রা", style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("গন্তব্য", style: TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
                          Text(train.destinationBn, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.slateDark)),
                          Text(train.arrTime, style: const TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.event_busy, size: 16, color: AppTheme.lateRed),
                          const SizedBox(width: 6),
                          Text("সাপ্তাহিক ছুটি: ${train.offDayBn}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.slateDark)),
                        ],
                      ),
                      Text("মোট দূরত্ব: ${train.totalDistanceKm.toStringAsFixed(0)} কিমি", style: const TextStyle(fontSize: 12, color: AppTheme.slateMuted)),
                    ],
                  ),
                ],
              ),
            ),

            // Class-wise Fare Table
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: const Text(
                "শ্রেণিভিত্তিক ভাড়া তালিকা (ভ্যাটসহ)",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
              ),
            ),
            const SizedBox(height: 8),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.4),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                    ),
                    children: const [
                      Padding(padding: EdgeInsets.all(10), child: Text("আসন শ্রেণি", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      Padding(padding: EdgeInsets.all(10), child: Text("শোভন", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      Padding(padding: EdgeInsets.all(10), child: Text("স্নিগ্ধা", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      Padding(padding: EdgeInsets.all(10), child: Text("এসি সিট", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                  ),
                  _buildFareRow("ঢাকা ⇄ চট্টগ্রাম", "৪০৫ ৳", "৭৭৭ ৳", "৯৩২ ৳"),
                  _buildFareRow("ঢাকা ⇄ বিমানবন্দর", "৫০ ৳", "৯৫ ৳", "১১০ ৳"),
                  _buildFareRow("বিমানবন্দর ⇄ চট্টগ্রাম", "৩৮০ ৳", "৭২৫ ৳", "৮৭৫ ৳"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Stoppage Timetable
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: const Text(
                "সকল স্টপেজ ও যাত্রাবিরতির সূচি",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
              ),
            ),
            const SizedBox(height: 8),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: train.stoppages.isNotEmpty ? train.stoppages.length : 3,
                separatorBuilder: (ctx, i) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  if (train.stoppages.isNotEmpty) {
                    final stop = train.stoppages[i];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 13,
                        backgroundColor: AppTheme.primaryLight,
                        child: Text("${i + 1}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                      ),
                      title: Text(stop.stationName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text("প্ল্যাটফর্ম: ${stop.platformNumber} · দূরত্ব: ${stop.distanceKm.toStringAsFixed(1)} কিমি", style: const TextStyle(fontSize: 11)),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("পৌঁছানো: ${stop.scheduledArrival}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          Text("ছাড়ার সময়: ${stop.scheduledDeparture}", style: const TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  TableRow _buildFareRow(String route, String shovon, String snigdha, String ac) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(10), child: Text(route, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        Padding(padding: const EdgeInsets.all(10), child: Text(shovon, style: const TextStyle(fontSize: 12))),
        Padding(padding: const EdgeInsets.all(10), child: Text(snigdha, style: const TextStyle(fontSize: 12))),
        Padding(padding: const EdgeInsets.all(10), child: Text(ac, style: const TextStyle(fontSize: 12))),
      ],
    );
  }
}
