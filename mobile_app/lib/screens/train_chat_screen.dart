import 'package:flutter/material.dart';
import '../models/train.dart';
import '../models/chat_message.dart';
import '../theme/app_theme.dart';

class TrainChatScreen extends StatefulWidget {
  final Train train;

  const TrainChatScreen({super.key, required this.train});

  @override
  State<TrainChatScreen> createState() => _TrainChatScreenState();
}

class _TrainChatScreenState extends State<TrainChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      trainCode: '702',
      senderName: 'রাকিব আহমেদ',
      text: 'ট্রেন কি কমলাপুর থেকে সঠিক সময়ে ছেড়েছে?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      reactions: {'👍': 4},
    ),
    ChatMessage(
      id: '2',
      trainCode: '702',
      senderName: 'তানভীর হাসান',
      text: 'হ্যাঁ ভাই, একদম ৪:৩০ এ ঠিক সময়ে ছেড়েছে। এখন তেজগাঁও পার হচ্ছে।',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      reactions: {'❤️': 8, '👍': 3},
    ),
    ChatMessage(
      id: '3',
      trainCode: '702',
      senderName: 'সোহেল রানা (বগি-খ)',
      text: 'প্ল্যাটফর্ম ২ এ উঠেছিল। বিমানবন্দর থেকে কেউ উঠবেন?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      reactions: {'👍': 5},
    ),
    ChatMessage(
      id: '4',
      trainCode: '702',
      senderName: 'মাহমুদুল ইসলাম',
      text: 'আমি বিমানবন্দরে আছি। ট্রেন কি ঢুকছে?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      reactions: {'😮': 2},
    ),
  ];

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          trainCode: widget.train.code,
          senderName: 'আপনি (যাত্রী)',
          text: text,
          timestamp: DateTime.now(),
        ),
      );
      _textController.clear();
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('${widget.train.nameBn} লাইভ চ্যাট'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.lightGreenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '৩৪ জন যাত্রী অনলাইনে',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'কমিউনিটি নিয়মাবলী',
            onPressed: () => _showChatGuidelineDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Announcement Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: Colors.blue[50],
            child: Row(
              children: [
                const Icon(Icons.campaign, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'সহযাত্রীদের সাথে ট্রেনের বর্তমান অবস্থা ও বিলম্বের তথ্য শেয়ার করুন।',
                    style: TextStyle(fontSize: 12, color: Colors.blue[900]),
                  ),
                ),
              ],
            ),
          ),

          // Message List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Quick Reaction Tray
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['👍', '❤️', '😂', '😮', '🙏'].map((emoji) {
                return InkWell(
                  onTap: () {
                    if (_messages.isNotEmpty) {
                      setState(() {
                        _messages.last.addReaction(emoji);
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(emoji, style: const TextStyle(fontSize: 20)),
                  ),
                );
              }).toList(),
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'সহযাত্রীদের কিছু লিখুন...',
                        filled: true,
                        fillColor: AppTheme.backgroundGrey,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryGreen,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isMe = msg.senderName.startsWith('আপনি');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.lightGreen,
              child: Text(
                msg.senderName[0],
                style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        msg.senderName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppTheme.lightGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'যাত্রী',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? AppTheme.primaryGreen : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isMe ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                ),
                // Reactions Display
                if (msg.reactions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Wrap(
                      spacing: 4,
                      children: msg.reactions.entries.map((entry) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            '${entry.key} ${entry.value}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showChatGuidelineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.shield_outlined, color: AppTheme.primaryGreen),
            SizedBox(width: 8),
            Text('কমিউনিটি নিয়মাবলী'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('১. সহযাত্রীদের সাথে ভদ্র ও শালীন আচরণ করুন।'),
            SizedBox(height: 6),
            Text('২. কোনো ধরনের ব্যক্তিগত গোপনীয় তথ্য বা OTP শেয়ার করবেন না।'),
            SizedBox(height: 6),
            Text('৩. ভুল বা বিভ্রান্তিকর ট্রেনের সময়সূচি দেওয়া থেকে বিরত থাকুন।'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('সম্মত আছি'),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }
}
