import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RailwaySafetyScreen extends StatelessWidget {
  const RailwaySafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("রেলওয়ে নিরাপত্তা ও হেল্পলাইন"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Emergency Helpline Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.lateRed.withOpacity(0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.emergency, color: AppTheme.lateRed, size: 24),
                    SizedBox(width: 8),
                    Text(
                      "জরুরি রেলওয়ে পুলিশ (GRP) হেল্পলাইন",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.lateRed),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "চলন্ত ট্রেনে যেকোনো অপরাধ, চুরি, বা বিপদে তাৎক্ষণিক রেলওয়ে নিরাপত্তা বাহিনীকে জানান।",
                  style: TextStyle(fontSize: 12, color: AppTheme.slateDark),
                ),
                SizedBox(height: 12),
                Divider(),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("কমলাপুর জিআরপি থানা:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text("০১৩২০-১৭৮৯০১", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.lateRed, fontSize: 13)),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("জাতীয় জরুরি সেবা:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text("৯৯৯ (টোল ফ্রি)", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.lateRed, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Safety Rules Cards
          _buildRuleCard(
            Icons.warning_amber_rounded,
            "ছাদ ও দরজায় দাঁড়িয়ে ভ্রমণ নিষেধ",
            "ট্রেনের দরজায় ঝুলে থাকা বা ছাদে ভ্রমণ আইনত দণ্ডনীয় অপরাধ। বৈদ্যুতিক তার ও ওভারহেড ব্রিজে মারাত্মক দুর্ঘটনার ঝুঁকি থাকে।",
          ),
          _buildRuleCard(
            Icons.phonelink_lock,
            "জানালায় মোবাইল সাবধানে রাখুন",
            "স্টেশনে ট্রেন থামার মুহূর্তে বা ধীরগতির সময় খোলা জানালায় মোবাইল হাতে রাখবেন না। ছিনতাইকারী থেকে সতর্ক থাকুন।",
          ),
          _buildRuleCard(
            Icons.luggage,
            "মালামাল ও লাগেজ বহনের নিয়মাবলী",
            "টিকিটধারী যাত্রী সর্বোচ্চ ৩৭ কেজি পর্যন্ত লাগেজ বিনামূল্যে নিতে পারেন। নিষিদ্ধ, দাহ্য বা অতিরিক্ত পণ্য বুকিং ছাড়া বহন করবেন না।",
          ),
          _buildRuleCard(
            Icons.verified_user_outlined,
            "অনলাইন টিকিট ভেরিফিকেশন",
            "টিকিট চেকিংয়ের সময় মূল এনআইডি কার্ড বা ফটোকপি সাথে রাখুন। অন্যের টিকিটে ভ্রমণ দণ্ডনীয় অপরাধ।",
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.slateDark)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppTheme.slateMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
