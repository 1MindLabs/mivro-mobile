import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mivro/features/chat/models/message.dart';

class ChatHistoriesNotifier extends Notifier<Map<String, List<Message>>> {
  @override
  Map<String, List<Message>> build() => {};

  List<Message> getHistory(String username) {
    if (!state.containsKey(username)) {
      state = {
        ...state,
        username: [
          Message(text: 'Hello @! How can I help you?', isUser: false),
        ],
      };
    }
    return state[username] ?? [];
  }

  void addMessage(String username, Message message) {
    final currentHistory = getHistory(username);
    state = {
      ...state,
      username: [...currentHistory, message],
    };
  }
}

final chatHistoriesProvider =
    NotifierProvider<ChatHistoriesNotifier, Map<String, List<Message>>>(
      ChatHistoriesNotifier.new,
    );

final chatHistoryProvider = Provider.family<List<Message>, String>((
  ref,
  username,
) {
  return ref.watch(
    chatHistoriesProvider.select(
      (histories) =>
          histories[username] ??
          [Message(text: 'Hello @! How can I help you?', isUser: false)],
    ),
  );
});
