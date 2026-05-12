import 'package:flutter/material.dart';
import 'chat_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _chats = [
    {
      'clientName': 'Sarah Jenkins',
      'avatarUrl': 'https://i.pravatar.cc/150?img=1',
      'projectTitle': 'Flutter UI Refactoring',
      'lastMessage': 'Great, the project requires someone with extensive...',
      'timestamp': '10:15 AM',
      'isOnline': true,
      'unreadCount': 2,
    },
    {
      'clientName': 'TechCorp Solutions',
      'avatarUrl': 'https://i.pravatar.cc/150?img=2',
      'projectTitle': 'E-commerce App MVP',
      'lastMessage': 'Could you send the latest APK?',
      'timestamp': 'Yesterday',
      'isOnline': false,
      'unreadCount': 0,
    },
    {
      'clientName': 'Michael Chen',
      'avatarUrl': 'https://i.pravatar.cc/150?img=3',
      'projectTitle': 'Bug fixing - Map Integration',
      'lastMessage': 'Thanks! I will review it later.',
      'timestamp': 'Mon',
      'isOnline': true,
      'unreadCount': 0,
    },
    {
      'clientName': 'Elena Rossi',
      'avatarUrl': 'https://i.pravatar.cc/150?img=4',
      'projectTitle': 'Ongoing Maintenance',
      'lastMessage': 'Can we schedule a call for next week?',
      'timestamp': 'May 1',
      'isOnline': false,
      'unreadCount': 0,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                    backgroundColor: Color(0xFFE5E7EB),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Messages',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF14A800), width: 1.5),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Color(0xFF14A800), size: 20),
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(Icons.search, color: Color(0xFF6B7280), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Color(0xFF111827), fontSize: 16),
                              decoration: const InputDecoration(
                                hintText: 'Search messages',
                                hintStyle: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(bottom: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Icon(Icons.tune, color: Color(0xFF111827), size: 20),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Chat List
            Expanded(
              child: ListView.separated(
                itemCount: _chats.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE5E7EB),
                  indent: 76,
                ),
                itemBuilder: (context, index) {
                  final chat = _chats[index];
                  final bool isOnline = chat['isOnline'];
                  final int unreadCount = chat['unreadCount'];
                  
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            clientName: chat['clientName'],
                            avatarUrl: chat['avatarUrl'],
                            projectTitle: chat['projectTitle'],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(chat['avatarUrl']),
                                backgroundColor: const Color(0xFFE5E7EB),
                              ),
                              if (isOnline)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF14A800),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2.5),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        chat['clientName'],
                                        style: TextStyle(
                                          color: const Color(0xFF111827),
                                          fontSize: 16,
                                          fontWeight: unreadCount > 0
                                              ? FontWeight.bold
                                              : FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      chat['timestamp'],
                                      style: TextStyle(
                                        color: unreadCount > 0
                                            ? const Color(0xFF14A800)
                                            : const Color(0xFF6B7280),
                                        fontSize: 12,
                                        fontWeight: unreadCount > 0
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  chat['projectTitle'],
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        chat['lastMessage'],
                                        style: TextStyle(
                                          color: unreadCount > 0
                                              ? const Color(0xFF111827)
                                              : const Color(0xFF4B5563),
                                          fontSize: 14,
                                          fontWeight: unreadCount > 0
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (unreadCount > 0)
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF14A800),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          unreadCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
