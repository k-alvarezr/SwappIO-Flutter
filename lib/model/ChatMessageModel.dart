class ChatMessageModel {
  const ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });

  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isRead;
}
