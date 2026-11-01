import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, String>> _notices = const [
    {
      "title": "রেলওয়ে সূচি পরিবর্তন",
      "time": "৮ ঘণ্টা আগে",
      "body": "পদ্মা সেতু সংযোগ লাইনে নতুন দুটি ট্রেনের সময়সূচি ঘোষণা করা হয়েছে।",
    },
    {
      "title": "ট্রেন অবস্থান শেয়ার",
      "time": "গতকাল",
      "body": "আপনার জিপিএস শেয়ারের জন্য +৫০ পয়েন্ট যোগ হয়েছে।",
    },
    {
      "title": "স্টেশন প্ল্যাটফর্ম আপডেট",
      "time": "২ দিন আগে",
      "body": "সোনার বাংলা এক্সপ্রেস আজ ৩ নম্বর প্ল্যাটফর্মে প্রবেশ করবে।",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("বিজ্ঞপ্তি ও ঘোষণা"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notices.length,
        itemBuilder: (ctx, i) {
          final n = _notices[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.campaign, color: Color(0xFF0F766E), size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          n["title"]!,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                      ),
                      Text(
                        n["time"]!,
                        style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    n["body"]!,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textBody, height: 1.4),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
