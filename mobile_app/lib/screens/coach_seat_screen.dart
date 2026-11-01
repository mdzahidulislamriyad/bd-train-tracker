import 'package:flutter/material.dart';
import '../models/train.dart';
import '../models/coach_layout.dart';
import '../theme/app_theme.dart';

class CoachSeatScreen extends StatefulWidget {
  final Train train;

  const CoachSeatScreen({super.key, required this.train});

  @override
  State<CoachSeatScreen> createState() => _CoachSeatScreenState();
}

class _CoachSeatScreenState extends State<CoachSeatScreen> {
  int _selectedCoachIndex = 0;

  final List<Coach> _coaches = [
    Coach.generateSample(name: 'ক (শোভন চেয়ার)', type: 'শোভন চেয়ার', facesForward: true),
    Coach.generateSample(name: 'খ (শোভন চেয়ার)', type: 'শোভন চেয়ার', facesForward: true),
    Coach.generateSample(name: 'গ (শোভন চেয়ার)', type: 'শোভন চেয়ার', facesForward: false),
    Coach.generateSample(name: 'স্নিগ্ধা-১ (এসি)', type: 'স্নিগ্ধা এসি চেয়ার', facesForward: true),
    Coach.generateSample(name: 'স্নিগ্ধা-২ (এসি)', type: 'স্নিগ্ধা এসি চেয়ার', facesForward: false),
  ];

  @override
  Widget build(BuildContext context) {
    final activeCoach = _coaches[_selectedCoachIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.train.nameBn} - বগি ও সিট প্ল্যান'),
      ),
      body: Column(
        children: [
          // 1. Coach Selector Horizontal Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(_coaches.length, (index) {
                  final isSelected = _selectedCoachIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(_coaches[index].name),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryGreen,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textDark,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedCoachIndex = index);
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
          ),

          // 2. Train Motion Direction Indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber[100],
              border: Border.all(color: Colors.amber[300]!),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_upward, size: 16, color: Colors.brown),
                SizedBox(width: 6),
                Text(
                  '▲ ট্রেনের চলার দিক (Direction of Motion) ▲',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.arrow_upward, size: 16, color: Colors.brown),
              ],
            ),
          ),

          // 3. Legend / Key
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(
                  color: Colors.green[100]!,
                  borderColor: Colors.green,
                  icon: Icons.arrow_upward,
                  label: 'চলার দিকে (Forward)',
                ),
                _buildLegendItem(
                  color: Colors.blue[100]!,
                  borderColor: Colors.blue,
                  icon: Icons.arrow_downward,
                  label: 'উল্টো দিকে (Reverse)',
                ),
                _buildLegendItem(
                  color: Colors.white,
                  borderColor: Colors.grey,
                  icon: Icons.window,
                  label: 'জানালা (Window)',
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 4. Graphical Coach Seat Layout
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: ListView.builder(
                itemCount: activeCoach.seatRows.length,
                itemBuilder: (context, rowIndex) {
                  final row = activeCoach.seatRows[rowIndex];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Window & Aisle Seats
                        Row(
                          children: [
                            _buildSeatButton(row[0]),
                            const SizedBox(width: 8),
                            _buildSeatButton(row[1]),
                          ],
                        ),

                        // Center Walking Aisle
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundGrey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'সারি ${rowIndex + 1}',
                            style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                          ),
                        ),

                        // Right Aisle & Window Seats
                        Row(
                          children: [
                            _buildSeatButton(row[2]),
                            const SizedBox(width: 8),
                            _buildSeatButton(row[3]),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // 5. Crowd-Confirmation Banner at bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppTheme.lightGreen,
            child: Row(
              children: [
                const Icon(Icons.how_to_vote_outlined, color: AppTheme.primaryGreen),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'সিট কি ট্রেনের সঠিক দিকে আছে?',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  child: const Text('হ্যাঁ, ঠিক আছে'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('আপনার সিট ডিরেকশন ভোট জমা হয়েছে!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required Color borderColor,
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor),
          ),
          child: Icon(icon, size: 12, color: borderColor),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textDark),
        ),
      ],
    );
  }

  Widget _buildSeatButton(SeatItem seat) {
    final bgColor = seat.isForwardFacing ? Colors.green[50] : Colors.blue[50];
    final borderColor = seat.isForwardFacing ? Colors.green[400]! : Colors.blue[400]!;

    return InkWell(
      onTap: () => _showSeatDetailsDialog(seat),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                seat.seatNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppTheme.textDark,
                ),
              ),
            ),
            // Window Icon badge if window seat
            if (seat.isWindow)
              Positioned(
                top: 2,
                right: 2,
                child: Icon(Icons.window, size: 10, color: Colors.grey[600]),
              ),
            // Forward/Reverse Direction Arrow badge
            Positioned(
              bottom: 2,
              right: 2,
              child: Icon(
                seat.isForwardFacing ? Icons.arrow_upward : Icons.arrow_downward,
                size: 11,
                color: seat.isForwardFacing ? Colors.green[700] : Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSeatDetailsDialog(SeatItem seat) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppTheme.lightGreen,
                  child: Icon(Icons.event_seat, color: AppTheme.primaryGreen),
                ),
                const SizedBox(width: 12),
                Text(
                  'সিট নম্বর: ${seat.seatNumber}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.navigation_outlined, color: AppTheme.primaryGreen),
              title: const Text('চলন দিক (Seat Direction)'),
              subtitle: Text(
                seat.isForwardFacing
                    ? 'ট্রেনের গতির দিকে মুখ করা (Forward Facing) — স্বাচ্ছন্দ্যময় ভ্রমণ'
                    : 'ট্রেনের চলার উল্টো দিকে মুখ করা (Reverse Facing)',
                style: TextStyle(
                  color: seat.isForwardFacing ? Colors.green[800] : Colors.blue[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.window_outlined, color: AppTheme.primaryGreen),
              title: const Text('অবস্থান (Position)'),
              subtitle: Text(seat.isWindow ? 'জানালার পাশে (Window Seat)' : 'আইল / রাস্তার পাশে (Aisle Seat)'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('বুঝেছি'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
