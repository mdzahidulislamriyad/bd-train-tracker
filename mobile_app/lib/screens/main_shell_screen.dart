import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'live_map_screen.dart';
import 'rewards_screen.dart';
import '../theme/app_theme.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const LiveMapScreen(),
    const _HistoryPlaceholderScreen(),
    const RewardsScreen(),
    const _NotificationPlaceholderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "হোম",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.near_me_outlined),
            activeIcon: Icon(Icons.near_me),
            label: "ড্যাশবোর্ড",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: "ইতিহাস",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            activeIcon: Icon(Icons.emoji_events),
            label: "রিওয়ার্ড",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: "বিজ্ঞপ্তি",
          ),
        ],
      ),
    );
  }
}

class _HistoryPlaceholderScreen extends StatelessWidget {
  const _HistoryPlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text("সাম্প্রতিক অনুসন্ধান ও ইতিহাস")),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _buildHistoryItem("ঢাকা ⇄ চট্টগ্রাম", "সোনার বাংলা এক্সপ্রেস (৭৮৮)", "আজ, ০৭:০০ AM"),
          _buildHistoryItem("ঢাকা ⇄ সিলেট", "কালনী এক্সপ্রেস (৭৭৪)", "গতকাল, ১৫:০০ PM"),
          _buildHistoryItem("খুলনা ⇄ ঢাকা", "সুন্দরবন এক্সপ্রেস (৭২৬)", "২৮ অক্টোবর"),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String route, String train, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryLight,
            child: const Icon(Icons.train, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(route, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(train, style: const TextStyle(fontSize: 12, color: AppTheme.slateMuted)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
        ],
      ),
    );
  }
}

class _NotificationPlaceholderScreen extends StatelessWidget {
  const _NotificationPlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text("বিজ্ঞপ্তি ও ঘোষণা")),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _buildNoticeItem("রেলওয়ে সূচি পরিবর্তন", "পদ্মা সেতু সংযোগ লাইনে নতুন দুটি ট্রেনের সময়সূচি ঘোষণা করা হয়েছে।", "১ ঘণ্টা আগে", isNew: true),
          _buildNoticeItem("ট্রেন অবস্থান শেয়ার", "আপনার জিপিএস শেয়ারের জন্য +৫০ পয়েন্ট যোগ হয়েছে।", "গতকাল"),
          _buildNoticeItem("স্টেশন প্ল্যাটফর্ম আপডেট", "সোনার বাংলা এক্সপ্রেস আজ ৩ নম্বর প্ল্যাটফর্মে প্রবেশ করবে।", "২ দিন আগে"),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(String title, String body, String time, {bool isNew = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isNew ? AppTheme.primaryLight.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isNew ? AppTheme.primary.withOpacity(0.3) : AppTheme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.campaign, color: isNew ? AppTheme.primary : AppTheme.slateMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(time, style: const TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(fontSize: 12, color: AppTheme.slateText)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
