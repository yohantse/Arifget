// ignore_for_file: unused_import

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_conversation.dart';
import '../models/chat_message.dart';

class MessageService {
  static const String baseUrl = 'https://api.dev.arifget.com';

  static Future<List<ChatConversation>> getConversations() async {
    // Mocking for now as API might not have this yet
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      ChatConversation(
        id: '1',
        clientName: 'Sarah Jenkins',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        projectTitle: 'Flutter UI Refactoring',
        lastMessage: 'Great, the project requires someone with extensive...',
        timestamp: '10:15 AM',
        isOnline: true,
        unreadCount: 2,
      ),
      ChatConversation(
        id: '2',
        clientName: 'TechCorp Solutions',
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        projectTitle: 'E-commerce App MVP',
        lastMessage: 'Could you send the latest APK?',
        timestamp: 'Yesterday',
        isOnline: false,
        unreadCount: 0,
      ),
    ];
  }

  static Future<List<ChatMessage>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ChatMessage(
        id: '101',
        senderId: 'client_1',
        text: 'Hi there! I saw your proposal.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
      ),
      ChatMessage(
        id: '102',
        senderId: 'me',
        text: 'Hello! Yes, I am very interested in the Flutter UI refactor.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isMe: true,
      ),
      ChatMessage(
        id: '103',
        senderId: 'client_1',
        text: 'Great, the project requires someone with extensive experience in Material 3.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isMe: false,
      ),
    ];
  }

  static Future<void> sendMessage(String conversationId, String text) async {
    // API call to send message
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
