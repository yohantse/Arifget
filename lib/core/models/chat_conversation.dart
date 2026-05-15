class ChatConversation {
  final String id;
  final String clientName;
  final String avatarUrl;
  final String projectTitle;
  final String lastMessage;
  final String timestamp;
  final bool isOnline;
  final int unreadCount;

  ChatConversation({
    required this.id,
    required this.clientName,
    required this.avatarUrl,
    required this.projectTitle,
    required this.lastMessage,
    required this.timestamp,
    required this.isOnline,
    this.unreadCount = 0,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'].toString(),
      clientName: json['client_name'] ?? 'Unknown',
      avatarUrl: json['avatar_url'] ?? '',
      projectTitle: json['project_title'] ?? '',
      lastMessage: json['last_message'] ?? '',
      timestamp: json['timestamp'] ?? '',
      isOnline: json['is_online'] ?? false,
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}
