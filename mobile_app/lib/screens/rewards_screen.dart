import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/train_provider.dart';
import '../theme/app_theme.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("রিওয়ার্ড ও কমিউনিটি পয়েন্ট"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Points Gradient Card (Screenshot 2)
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F766E), Color(0xFF115E59)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF0F766E).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  const Text("আপনার অর্জিত মোট পয়েন্ট", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Color(0xFFF59E0B), size: 28),
                      const SizedBox(width: 8),
                      Text(
                        "${provider.userPoints} পয়েন্ট",
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Color(0xFFF59E0B), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          provider.userTier,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Card 2: পয়েন্ট অর্জনের উপায় (Screenshot 2)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "পয়েন্ট অর্জনের উপায়",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                    ),
                    const SizedBox(height: 14),
                    _buildWayItem(
                      icon: Icons.location_on,
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF2E7D32),
                      title: "ট্রেনে লাইভ জিপিএস শেয়ার",
                      points: "+৫০ পয়েন্ট / যাত্রা",
                    ),
                    const Divider(height: 20, color: Color(0xFFF1F5F9)),
                    _buildWayItem(
                      icon: Icons.airline_seat_recline_normal,
                      iconBg: const Color(0xFFE0F2FE),
                      iconColor: const Color(0xFF0284C7),
                      title: "বগির অবস্থান ও সিটের দিক ভোট",
                      points: "+১০ পয়েন্ট / ভোট",
                    ),
                    const Divider(height: 20, color: Color(0xFFF1F5F9)),
                    _buildWayItem(
                      icon: Icons.pin_drop,
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF2E7D32),
                      title: "স্টেশনের নতুন সুবিধা পিন করা",
                      points: "+৩০ পয়েন্ট / পিন",
                    ),
                    const Divider(height: 20, color: Color(0xFFF1F5F9)),
                    _buildWayItem(
                      icon: Icons.search,
                      iconBg: const Color(0xFFE0F7FA),
                      iconColor: const Color(0xFF0097A7),
                      title: "হারানো জিনিস ফিরে পেতে সাহায্য",
                      points: "+১০০ পয়েন্ট",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Card 3: টপ কন্ট্রিবিউটর লিডারবোর্ড (Screenshot 2)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "টপ কন্ট্রিবিউটর লিডারবোর্ড",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                        Text("এই মাসের", style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildLeaderboardRow("1", "রাকিবুল হাসান", "১,৪৫০ পয়েন্ট", const Color(0xFFF59E0B)),
                    const SizedBox(height: 12),
                    _buildLeaderboardRow("2", "তানভীর আহমেদ", "১,২০০ পয়েন্ট", const Color(0xFF94A3B8)),
                    const SizedBox(height: 12),
                    _buildLeaderboardRow("3", "মেহেদী হাসান", "৯৮০ পয়েন্ট", const Color(0xFFD97706)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWayItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String points,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textDark),
          ),
        ),
        Text(
          points,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
        ),
      ],
    );
  }

  Widget _buildLeaderboardRow(String rank, String name, String points, Color rankBg) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(color: rankBg, shape: BoxShape.circle),
          child: Center(
            child: Text(
              rank,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark),
          ),
        ),
        Text(
          points,
          style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
        ),
      ],
    );
  }
}
