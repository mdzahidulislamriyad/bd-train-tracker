import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/lost_found_item.dart';
import '../theme/app_theme.dart';

class LostFoundDetailScreen extends StatelessWidget {
  final LostFoundItem item;

  const LostFoundDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isLost = item.type == ReportType.lost;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Type Badge Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLost ? Colors.red[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isLost ? Colors.red[300]! : Colors.green[300]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isLost ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                    color: isLost ? Colors.red[700] : Colors.green[700],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.type.labelBn,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isLost ? Colors.red[800] : Colors.green[800],
                    ),
                  ),
                  const Spacer(),
                  if (item.isResolved)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'সমাধান হয়েছে',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Item Title & Category
            Row(
              children: [
                Text(item.category.iconEmoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        item.category.labelBn,
                        style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            // Location Info Card
            _buildInfoRow(
              icon: Icons.train,
              title: 'ট্রেন',
              value: item.trainName,
            ),
            if (item.compartment.isNotEmpty)
              _buildInfoRow(
                icon: Icons.event_seat,
                title: 'বগি ও স্থান',
                value: item.compartment,
              ),
            _buildInfoRow(
              icon: Icons.access_time,
              title: 'তারিখ ও সময়',
              value: DateFormat('dd MMMM yyyy, hh:mm a').format(item.date),
            ),

            const SizedBox(height: 16),

            // Description Box
            const Text(
              'বিস্তারিত বিবরণ:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.backgroundGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item.description,
                style: const TextStyle(fontSize: 14, height: 1.5, color: AppTheme.textDark),
              ),
            ),

            const SizedBox(height: 20),

            // Contact Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'রিপোর্টার / যোগাযোগের তথ্য:',
                    style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.contactName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.phone, size: 16),
                        label: const Text('কল করুন'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('নম্বর: ${item.contactPhone}')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Claim Ownership Button (if found item)
            if (!isLost && !item.isResolved)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.assignment_turned_in_outlined),
                  label: const Text('এটি আমার পণ্য (Claim Ownership)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryGreen,
                    side: const BorderSide(color: AppTheme.primaryGreen, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _showClaimDialog(context),
                ),
              ),

            const SizedBox(height: 20),

            // Safety Warning
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber[300]!),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security, color: Colors.brown, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'সতর্কতা: পণ্য ফেরতের নামে কাউকে বিকাশ/নগদে অগ্রিম টাকা পাঠাবেন না। যাচাই করে সরাসরি স্টেশনে গ্রহণ করুন।',
                      style: TextStyle(fontSize: 11, color: Colors.brown),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryGreen),
          const SizedBox(width: 10),
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  void _showClaimDialog(BuildContext context) {
    final claimDetailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('মালিকানা দাবি করুন'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'পণ্যটি যে আপনার, তা প্রমাণ করার মতো কোনো গোপন চিহ্ন, রঙের শেড বা ভেতরের কোনো সুনির্দিষ্ট বস্তুর বর্ণনা লিখুন:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: claimDetailsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'প্রমাণের বিবরণ...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('বাতিল'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
            child: const Text('ক্লেইম পাঠান'),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppTheme.primaryGreen,
                  content: Text('আপনার দাবিটি গ্রহণ করা হয়েছে। রিপোর্টার যাচাই করে আপনার সাথে যোগাযোগ করবেন।'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
