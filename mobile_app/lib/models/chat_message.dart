class ChatMessage {
  final String id;
  final String trainCode;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final Map<String, int> reactions;
  final bool isVerifiedPassenger;

  ChatMessage({
    required this.id,
    required this.trainCode,
    required this.senderName,
    required this.text,
    required this.timestamp,
    Map<String, int>? reactions,
    this.isVerifiedPassenger = true,
  }) : reactions = reactions ?? {};

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      trainCode: json['train_code'] as String? ?? '',
      senderName: json['user'] as String? ?? 'সহযাত্রী',
      text: json['text'] as String? ?? '',
      timestamp: DateTime.tryParse(json['time'] as String? ?? '') ?? DateTime.now(),
      reactions: (json['reactions'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          {},
      isVerifiedPassenger: json['is_verified'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'train_code': trainCode,
      'user': senderName,
      'text': text,
      'time': timestamp.toIso8601String(),
      'reactions': reactions,
      'is_verified': isVerifiedPassenger,
    };
  }

  void addReaction(String emoji) {
    reactions[emoji] = (reactions[emoji] ?? 0) + 1;
  }
}
