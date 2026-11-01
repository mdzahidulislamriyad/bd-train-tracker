import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/train.dart';
import '../providers/train_provider.dart';
import '../theme/app_theme.dart';
import 'live_map_screen.dart';
import 'live_status_detail_screen.dart';
import 'journey_3d_screen.dart';

class LiveStatusScreen extends StatefulWidget {
  const LiveStatusScreen({super.key});

  @override
  State<LiveStatusScreen> createState() => _LiveStatusScreenState();
}

class _LiveStatusScreenState extends State<LiveStatusScreen> {
  int _tabIndex = 0; // 0: তালিকা, 1: ম্যাপ
  int _filterChipIndex = 0; // 0: ১০ মি, 1: ৩০ মি, 2: ১ ঘ, 3: ২ ঘ
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainProvider>();
    final trains = provider.allTrains.where((t) {
      if (_searchQuery.isEmpty) return true;
      return t.nameBn.contains(_searchQuery) ||
          t.code.contains(_searchQuery) ||
          t.originBn.contains(_searchQuery) ||
          t.destinationBn.contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // 1. Curved Magenta Header (Matches Screenshot 4)
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
                // Title and Subtitle Badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ট্রেন লাইভ স্ট্যাটাস",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(color: Color(0xFF4ADE80), shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "৪৭টি লাইভ ট্রেন • গত ১০ মিনিট",
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Tab Switcher Bar: [ 📋 তালিকা ] | [ 🗺️ ম্যাপ ] (Matches Screenshot 4)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
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
                      onTap: () => setState(() => _tabIndex = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _tabIndex == 0 ? const Color(0xFFFCE4EC) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.format_list_bulleted,
                              size: 16,
                              color: _tabIndex == 0 ? AppTheme.primary : AppTheme.textMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "তালিকা",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: _tabIndex == 0 ? FontWeight.bold : FontWeight.w500,
                                color: _tabIndex == 0 ? AppTheme.primary : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveMapScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _tabIndex == 1 ? const Color(0xFFFCE4EC) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map_outlined, size: 16, color: AppTheme.textMuted),
                            SizedBox(width: 6),
                            Text("ম্যাপ", style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Search Field: [ 🔍 ট্রেন নম্বর বা নাম; উৎস বা গন্তব্য ⌄ ]
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppTheme.textMuted, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "ট্রেন নম্বর বা নাম; উৎস বা গন্তব্য",
                        hintStyle: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                        border: InputBorder.none,
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: AppTheme.textMuted),
                ],
              ),
            ),
          ),

          // 4. Time Filter Chips: [ ১০ মি ] [ ৩০ মি ] [ ১ ঘ ] [ ২ ঘ ] [ ↺ ] [ ⇋ ]
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                _buildFilterChip(0, "১০ মি"),
                const SizedBox(width: 8),
                _buildFilterChip(1, "৩০ মি"),
                const SizedBox(width: 8),
                _buildFilterChip(2, "১ ঘ"),
                const SizedBox(width: 8),
                _buildFilterChip(3, "২ ঘ"),
                const SizedBox(width: 8),
                _buildIconFilterChip(Icons.refresh),
                const SizedBox(width: 8),
                _buildIconFilterChip(Icons.tune),
              ],
            ),
          ),

          // 5. Train Cards List (Matches Screenshot 4)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: trains.length,
              itemBuilder: (ctx, i) {
                return _buildTrainLiveCard(context, trains[i]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _filterChipIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _filterChipIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.primary : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppTheme.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildIconFilterChip(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Icon(icon, size: 16, color: AppTheme.textMuted),
    );
  }

  // --- TRAIN LIVE CARD (Matches Screenshot 4) ---
  Widget _buildTrainLiveCard(BuildContext context, Train train) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row 1: Train Name, Code Pill, "🟢 এইমাত্র", Chat Icon
            Row(
              children: [
                Text(
                  train.nameBn,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE4EC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    train.code,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primary),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    const Text("এইমাত্র", style: TextStyle(fontSize: 11, color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    const Icon(Icons.chat_bubble_outline, size: 14, color: Color(0xFF0D9488)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Row 2: Route & Off-day
            Text(
              "${train.originBn} - ${train.destinationBn} • 📅 বন্ধ: ${train.offDay}",
              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),

            const SizedBox(height: 10),

            // Row 3: Progress Bar with Percentage Tag (e.g. ৯২%)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${train.journeyCompletedPercent.toInt()}%",
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primary),
                ),
                const SizedBox(height: 2),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: train.journeyCompletedPercent / 100.0,
                    minHeight: 4,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Row 4: Departure Time, Duration, Arrival Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(train.depTime, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                const Text("৬ ঘ ৩৫ মি", style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                Text(train.arrTime, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              ],
            ),

            const SizedBox(height: 10),

            // Row 5: Action Button: [ 🟢 3D-তে ট্রেনের সাথে চলুন ]
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Journey3DScreen(train: train)),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    const Text(
                      "3D-তে ট্রেনের সাথে চলুন",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
