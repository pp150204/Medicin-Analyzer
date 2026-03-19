import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/chat_service.dart';

// Message model
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

// Chat state
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Chat provider
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;

  ChatNotifier(this._chatService) : super(ChatState()) {
    // Initial greeting
    addBotMessage("Hello! I'm your AI Health Assistant. Ask me anything about your health or medicines.");
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      // Get bot response
      final response = await _chatService.sendMessage(text);
      
      addBotMessage(response);
    } catch (e) {
      addBotMessage("Sorry, I'm having trouble connecting right now. Please try again.");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void addBotMessage(String text) {
    final botMessage = ChatMessage(
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    state = state.copyWith(
      messages: [...state.messages, botMessage],
    );
  }
}

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  return ChatNotifier(chatService);
});
