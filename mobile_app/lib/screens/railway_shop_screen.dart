import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RailwayShopScreen extends StatelessWidget {
  const RailwayShopScreen({super.key});

  final List<Map<String, dynamic>> _products = const [
    {
      "name": "রেলওয়ে লোকোমোটিভ টি-শার্ট",
      "price": 450,
      "category": "পোশাক",
      "desc": "প্রিমিয়াম ১০০% সুতি টি-শার্ট। সোনার বাংলা এক্সপ্রেস প্রিন্ট。",
      "icon": Icons.checkroom,
    },
    {
      "name": "ব্রাস ট্রেন মেটাল কি-রিং",
      "price": 180,
      "category": "এক্সেসরিজ",
      "desc": "খোদাই করা ব্রাস মেটাল লোকোমোটিভ চাবির রিং।",
      "icon": Icons.key,
    },
    {
      "name": "রেলওয়ে সিরামিক কফি মগ",
      "price": 280,
      "category": "স্মারক",
      "desc": "বাংলাদেশ রেলওয়ে গোল্ডেন জুবিলি স্পেশাল সিরামিক মগ।",
      "icon": Icons.coffee,
    },
    {
      "name": "লেদার ট্রেন টিকিট ওয়ালেট",
      "price": 350,
      "category": "ওয়ালেট",
      "desc": "টিকিট ও এনআইডি নিরাপদে বহনের জেনুইন লেদার কভার।",
      "icon": Icons.wallet,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("রেলওয়ে শপ ও অফার"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("কার্টে কোনো পণ্য যোগ করা নেই"), behavior: SnackBarBehavior.floating),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(14),
        gridDelegate: const dynamicDelegate(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: _products.length,
        itemBuilder: (ctx, index) {
          final p = _products[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.dividerColor),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: Center(
                      child: Icon(p['icon'] as IconData, size: 48, color: AppTheme.primary),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p['name'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "৳ ${p['price']}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primary),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${p['name']} কার্টে যোগ করা হয়েছে!"), behavior: SnackBarBehavior.floating),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          child: const Text("অর্ডার করুন"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class dynamicDelegate extends SliverGridDelegateWithFixedCrossAxisCount {
  const dynamicDelegate({
    required super.crossAxisCount,
    super.mainAxisSpacing = 0.0,
    super.crossAxisSpacing = 0.0,
    super.childAspectRatio = 1.0,
  });
}
