class ChatMessage {
  const ChatMessage({
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

class ChatChannel {
  const ChatChannel({
    required this.id,
    required this.participantIds,
    required this.participantNames,
    required this.participantProfilePics,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.unreadCount,
    this.relatedProductId,
    this.relatedProductName,
    this.relatedProductPrice,
    this.relatedProductImage,
    this.messages = const [],
  });

  final String id;
  final List<String> participantIds;
  final Map<String, String> participantNames;
  final Map<String, String?> participantProfilePics;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final int unreadCount;
  final String? relatedProductId;
  final String? relatedProductName;
  final double? relatedProductPrice;
  final String? relatedProductImage;
  final List<ChatMessage> messages;

  ChatChannel copyWith({
    String? id,
    List<String>? participantIds,
    Map<String, String>? participantNames,
    Map<String, String?>? participantProfilePics,
    String? lastMessage,
    DateTime? lastMessageTimestamp,
    int? unreadCount,
    String? relatedProductId,
    String? relatedProductName,
    double? relatedProductPrice,
    String? relatedProductImage,
    List<ChatMessage>? messages,
  }) {
    return ChatChannel(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      participantNames: participantNames ?? this.participantNames,
      participantProfilePics: participantProfilePics ?? this.participantProfilePics,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      relatedProductId: relatedProductId ?? this.relatedProductId,
      relatedProductName: relatedProductName ?? this.relatedProductName,
      relatedProductPrice: relatedProductPrice ?? this.relatedProductPrice,
      relatedProductImage: relatedProductImage ?? this.relatedProductImage,
      messages: messages ?? this.messages,
    );
  }
}
