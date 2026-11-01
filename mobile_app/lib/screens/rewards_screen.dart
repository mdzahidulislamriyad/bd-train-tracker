import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("রিওয়ার্ড ও কমিউনিটি পয়েন্ট"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // User Points Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  const Text("আপনার অর্জিত মোট পয়েন্ট", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.stars, color: AppTheme.accentGold, size: 30),
                      SizedBox(width: 8),
                      Text("৩৫০", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                      SizedBox(width: 6),
                      Text("পয়েন্ট", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "⭐ গোল্ড ট্রাভেলার টিয়ার",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Ways to Earn Points Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("পয়েন্ট অর্জনের উপায়", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateDark)),
                  const SizedBox(height: 10),
                  _buildEarnItem(Icons.location_on, "ট্রেনে লাইভ জিপিএস শেয়ার", "+৫০ পয়েন্ট / যাত্রা"),
                  _buildEarnItem(Icons.event_seat, "বগির অবস্থান ও সিটের দিক ভোট", "+১০ পয়েন্ট / ভোট"),
                  _buildEarnItem(Icons.pin_drop, "স্টেশনের নতুন সুবিধা পিন করা", "+৩০ পয়েন্ট / পিন"),
                  _buildEarnItem(Icons.find_in_page, "হারানো জিনিস ফিরে পেতে সাহায্য", "+১০০ পয়েন্ট"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Top Contributors Leaderboard
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("টপ কন্ট্রিবিউটর লিডারবোর্ড", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateDark)),
                      Text("এই মাসের", style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildLeaderItem(1, "রাকিবুল হাসান", "১,৪৫০ পয়েন্ট", isTop: true),
                  _buildLeaderItem(2, "তানভীর আহমেদ", "১,২০০ পয়েন্ট"),
                  _buildLeaderItem(3, "মেহেদী হাসান", "৯৮০ পয়েন্ট"),
                  _buildLeaderItem(4, "আপনার অবস্থান (#২৪)", "৩৫০ পয়েন্ট", isUser: true),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildEarnItem(IconData icon, String title, String points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppTheme.primaryLight,
            child: Icon(icon, color: AppTheme.primary, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 13, color: AppTheme.slateText))),
          Text(points, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary)),
        ],
      ),
    );
  }

  Widget _buildLeaderItem(int rank, String name, String points, {bool isTop = false, bool isUser = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isUser ? AppTheme.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isTop ? AppTheme.accentGold : AppTheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "$rank",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isTop ? Colors.white : AppTheme.slateDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isUser ? FontWeight.bold : FontWeight.w600,
                color: isUser ? AppTheme.primaryDark : AppTheme.slateDark,
              ),
            ),
          ),
          Text(
            points,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isUser ? AppTheme.primary : AppTheme.slateMuted,
            ),
          ),
        ],
      ),
    );
  }
}
