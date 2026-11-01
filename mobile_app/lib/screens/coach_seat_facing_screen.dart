import 'package:flutter/material.dart';
import '../models/train.dart';
import '../theme/app_theme.dart';

class CoachSeatFacingScreen extends StatefulWidget {
  final Train train;

  const CoachSeatFacingScreen({super.key, required this.train});

  @override
  State<CoachSeatFacingScreen> createState() => _CoachSeatFacingScreenState();
}

class _CoachSeatFacingScreenState extends State<CoachSeatFacingScreen> {
  String _selectedCoach = "ক";
  bool _isReversed = false;
  int _crowdConfirmedVotes = 18;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text("${widget.train.nameBn} - আসন অভিমুখ"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Coach Selector Chips
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: ["ক", "খ", "গ", "ঘ", "ঙ", "চ", "ছ", "জ", "ঝ", "ঞ", "ট"].map((code) {
                    final isSelected = code == _selectedCoach;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text("বগি $code"),
                        selected: isSelected,
                        selectedColor: AppTheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.slateDark,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedCoach = code);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Motion Direction Banner
            Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_upward_rounded, color: AppTheme.primary, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        "ট্রেন চলার দিক (${widget.train.destinationBn})",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isReversed
                        ? "যাত্রীদের ভোটে এই ট্রিপে বগিটি উল্টো মুখে যুক্ত রয়েছে।"
                        : "এই বগির সামনের সারির আসনগুলো ট্রেন চলার দিকে মুখ করে আছে।",
                    style: const TextStyle(fontSize: 12, color: AppTheme.slateMuted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(width: 12, height: 12, decoration: const BoxDecoration(color: AppTheme.onTimeGreen, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          const Text("ট্রেনমুখী (ফরওয়ার্ড)", style: TextStyle(fontSize: 12, color: AppTheme.slateText)),
                        ],
                      ),
                      Row(
                        children: [
                          Container(width: 12, height: 12, decoration: const BoxDecoration(color: AppTheme.lateRed, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          const Text("পেছনমুখী (রিভার্স)", style: TextStyle(fontSize: 12, color: AppTheme.slateText)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Seat Layout Diagram
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Column(
                children: [
                  // Front Door
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Text(
                        "সম্মুখ দরজা ও ইঞ্জিন প্রান্ত",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.slateMuted),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2x2 Seat Rows
                  for (int row = 1; row <= 8; row++) _buildSeatRow(row),

                  const SizedBox(height: 10),
                  // Rear Door
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Text(
                        "পেছনের দরজা ও টয়লেট",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.slateMuted),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Crowd Direction Flip Vote Card
            Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.how_to_vote_outlined, color: AppTheme.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "আসনের দিক কি উল্টো?",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                        ),
                        Text(
                          "$_crowdConfirmedVotes জন যাত্রী নিশ্চিত করেছেন",
                          style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isReversed = !_isReversed;
                        _crowdConfirmedVotes += 1;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("আপনার মতামত গ্রহণ করা হয়েছে। ধন্যবাদ!"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text("দিক উল্টান"),
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

  Widget _buildSeatRow(int row) {
    final seat1 = (row - 1) * 4 + 1;
    final seat2 = (row - 1) * 4 + 2;
    final seat3 = (row - 1) * 4 + 3;
    final seat4 = (row - 1) * 4 + 4;

    // First 4 rows face forward, remaining face reverse (or vice versa if flipped)
    final isRowForward = _isReversed ? (row > 4) : (row <= 4);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildSeatBox("$seat1", isRowForward, isWindow: true),
              const SizedBox(width: 6),
              _buildSeatBox("$seat2", isRowForward),
            ],
          ),
          // Aisle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "$row",
              style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted),
            ),
          ),
          Row(
            children: [
              _buildSeatBox("$seat3", isRowForward),
              const SizedBox(width: 6),
              _buildSeatBox("$seat4", isRowForward, isWindow: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatBox(String number, bool isForward, {bool isWindow = false}) {
    final color = isForward ? AppTheme.onTimeGreen : AppTheme.lateRed;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1.4),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: Icon(
              isForward ? Icons.arrow_upward : Icons.arrow_downward,
              size: 10,
              color: color,
            ),
          ),
          if (isWindow)
            const Positioned(
              bottom: 2,
              left: 2,
              child: Text(
                "W",
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.slateMuted),
              ),
            ),
        ],
      ),
    );
  }
}
