import 'package:flutter/material.dart';
import '../models/train.dart';
import '../theme/app_theme.dart';

class Journey3DScreen extends StatelessWidget {
  final Train train;

  const Journey3DScreen({super.key, required this.train});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("${train.nameBn} - ৩ডি জার্নি ভিউ"),
      ),
      body: Stack(
        children: [
          // 3D Perspective Grid Background
          Positioned.fill(
            child: CustomPaint(
              painter: _Journey3DPainter(),
            ),
          ),

          // Top Info Card
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${train.nameBn} (${train.code})",
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "${train.currentSpeed.toStringAsFixed(0)} কিমি/ঘ",
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "বর্তমান লোকেশন: ${train.nextStationName.isNotEmpty ? train.nextStationName : 'ট্র্যাকে চলমান'}",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // Train Avatar on Track
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppTheme.accentGold.withOpacity(0.6), blurRadius: 20, spreadRadius: 4),
                    ],
                  ),
                  child: const Icon(Icons.train, color: Colors.black, size: 36),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${train.completedDistanceKm.toStringAsFixed(0)} কিমি অতিক্রান্ত",
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Stops Strip
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStopNode(train.originBn, isPassed: true),
                  const Expanded(child: Divider(color: Colors.white30, indent: 8, endIndent: 8)),
                  _buildStopNode(train.nextStationName.isNotEmpty ? train.nextStationName : "মাঝের স্টেশন", isCurrent: true),
                  const Expanded(child: Divider(color: Colors.white30, indent: 8, endIndent: 8)),
                  _buildStopNode(train.destinationBn),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopNode(String title, {bool isPassed = false, bool isCurrent = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: isCurrent ? AppTheme.accentGold : (isPassed ? AppTheme.primary : Colors.white30),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: isCurrent ? AppTheme.accentGold : Colors.white70,
            fontSize: 11,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _Journey3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.0;

    // Draw perspective railway grid
    final centerX = size.width / 2;
    for (double i = -size.width; i <= size.width * 2; i += 40) {
      canvas.drawLine(Offset(centerX, size.height * 0.2), Offset(i, size.height), paint);
    }

    for (double y = size.height * 0.3; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
