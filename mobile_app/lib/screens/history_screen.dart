import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  final List<Map<String, String>> _historyItems = const [
    {
      "route": "ঢাকা ⇄ চট্টগ্রাম",
      "train": "সোনার বাংলা এক্সপ্রেস (৭৮৮)",
      "time": "আজ, ০৭:০০ AM",
    },
    {
      "route": "ঢাকা ⇄ সিলেট",
      "train": "কালনী এক্সপ্রেস (৭৭৪)",
      "time": "গতকাল, ১৫:০০ PM",
    },
    {
      "route": "খুলনা ⇄ ঢাকা",
      "train": "সুন্দরবন এক্সপ্রেস (৭২৬)",
      "time": "২৮ অক্টোবর",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("সাম্প্রতিক অনুসন্ধান ও ইতিহাস"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _historyItems.length,
        itemBuilder: (ctx, i) {
          final item = _historyItems[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.train, color: Color(0xFF2E7D32), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["route"]!,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item["train"]!,
                          style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    item["time"]!,
                    style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
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
