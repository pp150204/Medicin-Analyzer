import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  ChatService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
      systemInstruction: Content.text(
        "You are a helpful and empathetic AI Health Assistant. "
        "Your goal is to provide general health information and guidance on medicines. "
        "ALWAYS clarify that you are an AI and not a doctor. "
        "Advise users to consult a healthcare professional for serious medical issues. "
        "Keep responses concise and easy to understand. "
        "FORMAT ALL ANSWERS IN CLEAR MARKDOWN (headings, bullet lists, bold for key terms). "
        "Do not use markdown code blocks or fenced code; only plain markdown text."
      ),
    );
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      return response.text ??
          "I'm sorry, I couldn't generate a response. Please try again.";
    } catch (e) {
      // 👇 ADD THIS LINE
      print('ChatService error: $e');

      if (e.toString().contains('API_KEY_INVALID')) {
        return "Error: Invalid API Key. Please check your configuration.";
      }
      return "I'm having trouble connecting to the service. Please check your internet connection.";
    }
  }
}
