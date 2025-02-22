import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mivro/presentation/chat/model/message.dart';

class ChatHistoryNotifier extends StateNotifier<List<Message>> {
  ChatHistoryNotifier(String username)
      : super([
          Message(text: 'Hello @$username! How can I help you?', isUser: false)
        ]);

  void addMessage(Message message) {
    state = [...state, message];
  }
}

// Chat history provider that requires a username
final chatHistoryProvider = StateNotifierProvider.family<ChatHistoryNotifier, List<Message>, String>(
  (ref, username) => ChatHistoryNotifier(username),
);
