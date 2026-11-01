import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/lost_found_item.dart';
import '../services/lost_found_service.dart';
import '../theme/app_theme.dart';
import 'submit_lost_found_screen.dart';
import 'lost_found_detail_screen.dart';

class LostFoundScreen extends StatefulWidget {
  const LostFoundScreen({super.key});

  @override
  State<LostFoundScreen> createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends State<LostFoundScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LostFoundService _service = LostFoundService();
  ItemCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('হারানো ও প্রাপ্তি নোটিশ বোর্ড'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppTheme.accentOrange,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'সকল পোস্ট'),
            Tab(text: 'হারিয়ে গেছে'),
            Tab(text: 'পাওয়া গেছে'),
          ],
          onTap: (_) => setState(() {}),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.accentOrange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('রিপোর্ট পোস্ট করুন', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const SubmitLostFoundScreen()),
          );
          if (added == true) setState(() {});
        },
      ),
      body: Column(
        children: [
          // Category filter horizontal chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: const Text('সকল'),
                    selected: _selectedCategory == null,
                    selectedColor: AppTheme.lightGreen,
                    onSelected: (_) => setState(() => _selectedCategory = null),
                  ),
                ),
                ...ItemCategory.values.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text('${cat.iconEmoji} ${cat.labelBn}'),
                      selected: isSelected,
                      selectedColor: AppTheme.lightGreen,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                    ),
                  );
                }),
              ],
            ),
          ),

          const Divider(height: 1),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildItemList(type: null),
                _buildItemList(type: ReportType.lost),
                _buildItemList(type: ReportType.found),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList({ReportType? type}) {
    final list = _service.getFilteredItems(type: type, category: _selectedCategory);

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 54, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const Text(
              'কোনো রিপোর্ট পাওয়া যায়নি',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'আপনার কোনো পণ্য হারিয়ে বা পেয়ে থাকলে নিচে রিপোর্ট করুন।',
              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final isLost = item.type == ReportType.lost;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LostFoundDetailScreen(item: item),
                ),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge & Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLost ? Colors.red[50] : Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isLost ? Colors.red[200]! : Colors.green[200]!,
                          ),
                        ),
                        child: Text(
                          item.type.labelBn,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isLost ? Colors.red[700] : Colors.green[700],
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM, hh:mm a').format(item.date),
                        style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Title & Emoji
                  Row(
                    children: [
                      Text(item.category.iconEmoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Train & compartment
                  Row(
                    children: [
                      const Icon(Icons.train, size: 14, color: AppTheme.primaryGreen),
                      const SizedBox(width: 4),
                      Text(
                        item.trainName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      if (item.compartment.isNotEmpty) ...[
                        const Text(' • '),
                        Expanded(
                          child: Text(
                            item.compartment,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Description snippet
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                  ),

                  const SizedBox(height: 10),

                  // Bottom action bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            item.contactName,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      TextButton(
                        child: const Text('বিস্তারিত দেখুন ➔'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LostFoundDetailScreen(item: item),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
