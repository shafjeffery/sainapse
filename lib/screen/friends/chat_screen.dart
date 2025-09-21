import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'friends_screen.dart';

class ChatScreen extends StatefulWidget {
  final Friend friend;

  const ChatScreen({super.key, required this.friend});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Add some sample messages for demo
    _messages.addAll([
      ChatMessage(
        text: "Can you share your notes UI/UX?",
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatMessage(
        text: "Sure",
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      ChatMessage(
        text: "UI/UX Simple Notes",
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        isFile: true,
      ),
    ]);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add(
        ChatMessage(text: message, isUser: true, timestamp: DateTime.now()),
      );
    });

    _scrollToBottom();

    // Simulate friend response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: _getRandomResponse(),
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
        _scrollToBottom();
      }
    });
  }

  String _getRandomResponse() {
    final responses = [
      "Thanks for sharing!",
      "That's really helpful",
      "I'll check it out",
      "Great work!",
      "Can you explain more?",
      "This is exactly what I needed",
      "Awesome!",
      "Let me know if you need help",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  void _sendSuggestedMessage(String message) {
    _messageController.text = message;
    _sendMessage();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB), // Light yellow/cream background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9DB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2C2C2C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: widget.friend.avatarColor,
              child: Text(
                widget.friend.name.split(' ').map((e) => e[0]).join(),
                style: GoogleFonts.museoModerno(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.friend.name,
              style: GoogleFonts.museoModerno(
                color: const Color(0xFF2C2C2C),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Suggested questions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _buildSuggestionButton(
                    "How much cost?",
                    () => _sendSuggestedMessage("How much does it cost?"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSuggestionButton(
                    "Who build this?",
                    () => _sendSuggestedMessage("Who built this?"),
                  ),
                ),
              ],
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.museoModerno(
                          color: Colors.grey[500],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      style: GoogleFonts.museoModerno(
                        color: const Color(0xFF2C2C2C),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      maxLines: null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2C2C),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_upward, color: Colors.grey, size: 14),
            const SizedBox(width: 4),
            Text(
              text,
              style: GoogleFonts.museoModerno(
                color: const Color(0xFF2C2C2C),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: widget.friend.avatarColor,
              child: Text(
                widget.friend.name.split(' ').map((e) => e[0]).join(),
                style: GoogleFonts.museoModerno(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Colors.grey[200] // Light grey for user messages
                    : Colors.white, // White for friend messages
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: message.isFile
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.attach_file,
                          color: Color(0xFF2C2C2C),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          message.text,
                          style: GoogleFonts.museoModerno(
                            color: const Color(0xFF2C2C2C),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      message.text,
                      style: GoogleFonts.museoModerno(
                        color: const Color(0xFF2C2C2C),
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Text(
                'Me',
                style: GoogleFonts.museoModerno(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isFile;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isFile = false,
  });
}
