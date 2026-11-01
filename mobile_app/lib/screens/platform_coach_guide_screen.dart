import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/train.dart';
import '../models/platform_coach_item.dart';
import '../providers/train_provider.dart';
import '../theme/app_theme.dart';

class PlatformCoachGuideScreen extends StatefulWidget {
  final Train train;

  const PlatformCoachGuideScreen({super.key, required this.train});

  @override
  State<PlatformCoachGuideScreen> createState() => _PlatformCoachGuideScreenState();
}

class _PlatformCoachGuideScreenState extends State<PlatformCoachGuideScreen> {
  String _selectedStation = "ঢাকা (কমলাপুর)";
  String _myCoachCode = "ঘ";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainProvider>();
    final guide = provider.getPlatformGuide(widget.train, _selectedStation);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("প্ল্যাটফর্মে বগির অবস্থান"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Station and Train Selector Card
            Container(
              margin: const EdgeInsets.all(14),
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
                      Text(
                        "${widget.train.nameBn} (${widget.train.code})",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          guide.platformName,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    guide.directionDescription,
                    style: const TextStyle(fontSize: 13, color: AppTheme.slateMuted),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),

                  // My coach picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "আপনার টিকিট করা বগি:",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                      ),
                      DropdownButton<String>(
                        value: _myCoachCode,
                        underline: const SizedBox(),
                        items: ["ক", "খ", "গ", "ঘ", "ঙ", "চ", "ছ", "জ", "ঝ", "ঞ", "ট"]
                            .map((code) => DropdownMenuItem(value: code, child: Text("বগি $code")))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _myCoachCode = val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tip Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.accentAmber, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "ট্রেন আসার আগেই প্ল্যাটফর্মে আপনার বগি থামার জায়গায় গিয়ে দাঁড়ান। ফুটওভার ব্রিজ ও সিঁড়ির অবস্থান নিচে চিহ্নিত রয়েছে।",
                      style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Visual Platform Map
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: const Text(
                "প্ল্যাটফর্ম ও বগির ক্রমবিন্যাস",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
              ),
            ),
            const SizedBox(height: 10),

            // Train Carriage Track Representation
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Column(
                children: [
                  // Direction Arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_upward, size: 18, color: AppTheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        "ট্রেন চলার দিক (${widget.train.destinationBn}-এর দিকে)",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Coaches Column
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: guide.coaches.length,
                    itemBuilder: (ctx, index) {
                      final coach = guide.coaches[index];
                      final isSelected = coach.coachCode == _myCoachCode;
                      final isNearStairs = coach.platformSegmentNumber == guide.footbridgeSegment;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryLight : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppTheme.primary : AppTheme.dividerColor,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Coach Badge
                            Container(
                              width: 44,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primary : AppTheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  coach.coachCode,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : AppTheme.slateDark,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Coach Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    coach.coachName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                      color: AppTheme.slateDark,
                                    ),
                                  ),
                                  if (isNearStairs)
                                    const Row(
                                      children: [
                                        Icon(Icons.stairs, size: 14, color: AppTheme.accentAmber),
                                        SizedBox(width: 4),
                                        Text(
                                          "সিঁড়ি ও ফুটওভার ব্রিজের সামনে থামবে",
                                          style: TextStyle(fontSize: 11, color: AppTheme.accentAmber, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),

                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.person_pin_circle, size: 14, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      "আপনার বগি",
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
