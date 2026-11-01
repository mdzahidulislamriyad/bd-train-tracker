import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/train.dart';
import '../providers/train_provider.dart';
import '../theme/app_theme.dart';
import '../screens/live_map_screen.dart';
import '../screens/coach_seat_screen.dart';
import '../screens/train_chat_screen.dart';

class TrainCard extends StatelessWidget {
  final Train train;

  const TrainCard({
    super.key,
    required this.train,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainProvider>();
    final isTrackingThisTrain =
        provider.isOnTrainTracking && provider.currentLiveLocation?.trainCode == train.code;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isTrackingThisTrain
            ? const BorderSide(color: AppTheme.primaryGreen, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header: Train name & Code + Off day badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        train.nameBn,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        '${train.name} (${train.code}) • ${train.type}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: train.isOffToday ? Colors.red[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: train.isOffToday ? Colors.red[200]! : Colors.green[200]!,
                    ),
                  ),
                  child: Text(
                    train.isOffToday ? 'আজ বন্ধ (${train.offDayBn})' : 'আজ চলবে',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: train.isOffToday ? Colors.red[700] : AppTheme.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1),
            ),
            // Schedule Row (Departure -> Duration -> Arrival)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Origin
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      train.depTime,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Text(
                      train.originBn,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
                // Arrow & Duration
                Column(
                  children: [
                    Text(
                      train.travelDuration,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentOrange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(width: 25, height: 2, color: Colors.grey[300]),
                        const Icon(Icons.arrow_forward, color: AppTheme.primaryGreen, size: 16),
                        Container(width: 25, height: 2, color: Colors.grey[300]),
                      ],
                    ),
                  ],
                ),
                // Destination
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      train.arrTime,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Text(
                      train.destinationBn,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Action Row 1: Live Map & "I am on train"
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('লাইভ ম্যাপ'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryGreen,
                      side: const BorderSide(color: AppTheme.primaryGreen),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LiveMapScreen(train: train),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      isTrackingThisTrain ? Icons.location_on : Icons.navigation_outlined,
                      size: 18,
                    ),
                    label: Text(
                      isTrackingThisTrain ? 'ট্র্যাকিং চলছে' : 'আমি ট্রেনে আছি',
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isTrackingThisTrain ? AppTheme.accentOrange : AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _showOnTrainConsentDialog(context, train, provider);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Action Row 2: Coach Seat Plan & Live Chat
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.event_seat_outlined, size: 16, color: AppTheme.textDark),
                    label: const Text(
                      'বগি ও সিট প্ল্যান',
                      style: TextStyle(fontSize: 12, color: AppTheme.textDark),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.backgroundGrey,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CoachSeatScreen(train: train),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.blue),
                    label: const Text(
                      'যাত্রী লাইভ চ্যাট',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TrainChatScreen(train: train),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOnTrainConsentDialog(
    BuildContext context,
    Train train,
    TrainProvider provider,
  ) {
    if (provider.isOnTrainTracking) {
      provider.toggleOnTrainTracking(train);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('লোকেশন ট্র্যাকিং বন্ধ করা হয়েছে।')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            const Icon(Icons.share_location, color: AppTheme.primaryGreen),
            const SizedBox(width: 8),
            Text('${train.nameBn} ট্র্যাকিং'),
          ],
        ),
        content: const Text(
          'আপনি কি নিশ্চিত যে আপনি বর্তমানে এই ট্রেনের ভেতরে আছেন?\n\n'
          'লোকেশন শেয়ার করলে অন্য যাত্রীরা ট্রেনের বর্তমান লাইভ অবস্থান ও গতি দেখতে পারবেন।',
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            child: const Text('বাতিল'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
            child: const Text('হ্যাঁ, আমি ট্রেনে আছি'),
            onPressed: () {
              Navigator.pop(ctx);
              provider.toggleOnTrainTracking(train);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppTheme.primaryGreen,
                  content: Text('${train.nameBn} ট্র্যাকিং সক্রিয় করা হয়েছে!'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
