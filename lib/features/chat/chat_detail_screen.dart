import 'package:flutter/material.dart';

import '../../core/services/app_services.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/app_user.dart';
import '../../data/models/chat_models.dart';
import '../../routes/app_routes.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key, required this.chatId});

  final String chatId;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _chatRepository = AppServices.instance.chatRepository;
  final _userRepository = AppServices.instance.userRepository;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Object>>(
      future: Future.wait<Object>([
        _userRepository.getCurrentUser(),
        _chatRepository.getChatById(widget.chatId),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final currentUser = snapshot.data![0] as AppUser;
        final chat = snapshot.data![1] as ChatChannel;
        final otherUserId = chat.participantIds.firstWhere((id) => id != currentUser.id);
        final otherUserName = chat.participantNames[otherUserId] ?? 'Usuario';
        return Scaffold(
      backgroundColor: const Color(0xFFF5F8F8),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.white.withOpacity(0.85),
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                  child: Row(
                    children: [
                      IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_rounded)),
                      CircleAvatar(backgroundColor: Colors.white, child: Text(otherUserName.substring(0, 1))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(otherUserName, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF004E5E))),
                            const Text('Activo ahora', style: TextStyle(fontSize: 10, color: AppColors.accent, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
                    ],
                  ),
                ),
                if (chat.relatedProductId != null)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(colors: [Color(0xFFDCC4B8), Color(0xFFF6EDE3)]),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(chat.relatedProductName ?? '', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                              const SizedBox(height: 4),
                              Text('\$${(chat.relatedProductPrice ?? 0).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        FilledButton(
                          onPressed: chat.relatedProductId == null
                              ? null
                              : () => Navigator.of(context).pushNamed(
                                    AppRoutes.productDetail,
                                    arguments: chat.relatedProductId!,
                                  ),
                          child: const Text('Ver detalle'),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                    itemCount: chat.messages.length,
                    itemBuilder: (context, index) {
                      final message = chat.messages[index];
                      final isCurrentUser = message.senderId == currentUser.id;
                      return Align(
                        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: const BoxConstraints(maxWidth: 280),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isCurrentUser ? AppColors.primary : Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
                                    bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
                                  ),
                                ),
                                child: Text(message.text, style: TextStyle(color: isCurrentUser ? Colors.white : AppColors.textPrimary)),
                              ),
                              const SizedBox(height: 4),
                              Text(_timeString(message.timestamp), style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(50)),
                child: Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.add_rounded)),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          border: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: IconButton(
                        onPressed: _controller.text.trim().isEmpty
                            ? null
                            : () async {
                                await _chatRepository.sendMessage(widget.chatId, _controller.text);
                                if (!mounted) return;
                                setState(() {
                                  _controller.clear();
                                });
                              },
                        icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
        );
      },
    );
  }

  String _timeString(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}
