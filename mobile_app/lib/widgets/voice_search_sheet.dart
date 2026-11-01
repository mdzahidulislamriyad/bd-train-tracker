import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/train.dart';
import '../providers/train_provider.dart';
import '../services/voice_nlp_service.dart';
import '../theme/app_theme.dart';
import '../screens/live_map_screen.dart';

class VoiceSearchSheet extends StatefulWidget {
  const VoiceSearchSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const VoiceSearchSheet(),
    );
  }

  @override
  State<VoiceSearchSheet> createState() => _VoiceSearchSheetState();
}

class _VoiceSearchSheetState extends State<VoiceSearchSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final VoiceNlpService _nlpService = VoiceNlpService();

  bool _isListening = true;
  String _recognizedText = 'বলুন, শুনছি...';
  VoiceQueryResult? _result;

  final List<String> _sampleVoiceQueries = [
    'ঢাকা থেকে চট্টগ্রাম',
    'সুবর্ণ এক্সপ্রেস কখন ছাড়বে',
    'কক্সবাজারের ট্রেন',
    'সোনার বাংলা এক্সপ্রেস',
    'ঢাকা থেকে সিলেট',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _processVoiceInput(String text) {
    setState(() {
      _isListening = false;
      _recognizedText = text;
    });

    // Simulate natural thinking delay
    Future.delayed(const Duration(milliseconds: 400), () {
      final res = _nlpService.parseBengaliQuery(text);
      if (mounted) {
        setState(() {
          _result = res;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.record_voice_over, color: AppTheme.primaryGreen),
                    SizedBox(width: 8),
                    Text(
                      'ভয়েস এআই সার্চ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. Spoken Text Bubble
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _recognizedText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                        if (_isListening) ...[
                          const SizedBox(height: 6),
                          const Text(
                            'বাংলায় স্পষ্ট করে ট্রেনের নাম বা রুটের কথা বলুন',
                            style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 2. Animated Pulsing Microphone
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isListening = true;
                        _result = null;
                        _recognizedText = 'বলুন, শুনছি...';
                      });
                    },
                    child: AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        final scale = _isListening ? 1.0 + (_animController.value * 0.15) : 1.0;
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isListening ? AppTheme.primaryGreen : Colors.grey[400],
                              boxShadow: _isListening
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.primaryGreen.withOpacity(0.35),
                                        blurRadius: 20 * _animController.value,
                                        spreadRadius: 8 * _animController.value,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: const Icon(Icons.mic, color: Colors.white, size: 40),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. AI Query Answer Section
                  if (_result != null) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: Colors.blue),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _result!.spokenResponseBn,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Matched Trains list
                    ..._result!.matchedTrains.map((train) => _buildTrainMiniCard(context, train)),

                    const SizedBox(height: 10),

                    // Apply to Home Search Button
                    if (_result!.fromStation != null && _result!.toStation != null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.search),
                          label: const Text('এই রুটের সব তথ্য হোমে দেখুন'),
                          onPressed: () {
                            final prov = context.read<TrainProvider>();
                            prov.setFromStation(_result!.fromStation!);
                            prov.setToStation(_result!.toStation!);
                            prov.searchTrains();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                  ] else ...[
                    // 4. Sample Suggested Voice Prompts
                    const Text(
                      'অথবা নিচের যেকোনো একটি প্রশ্নে ট্যাপ করুন:',
                      style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: _sampleVoiceQueries.map((query) {
                        return ActionChip(
                          avatar: const Icon(Icons.mic_none, size: 16, color: AppTheme.primaryGreen),
                          label: Text(query),
                          backgroundColor: AppTheme.backgroundGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          onPressed: () => _processVoiceInput(query),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainMiniCard(BuildContext context, Train train) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppTheme.lightGreen,
          child: Icon(Icons.directions_subway, color: AppTheme.primaryGreen, size: 20),
        ),
        title: Text(
          train.nameBn,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text('${train.originBn} (${train.depTime}) ➔ ${train.destinationBn} (${train.arrTime})'),
        trailing: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          ),
          child: const Text('ম্যাপ', style: TextStyle(fontSize: 12)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LiveMapScreen(train: train)),
            );
          },
        ),
      ),
    );
  }
}
