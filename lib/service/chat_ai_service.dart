import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatAiService {
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  late GenerativeModel model;

  // Need to re-check ??
  // static final clientId = dotenv.env['GEMINI_API_KEY'] ?? '';

  ChatAiService() {
    model = GenerativeModel(model: "gemini-1.5-flash", apiKey: apiKey);
  }

  Future<String> sendMessage(String message) async {
    try {
      var chat = model.startChat();
      var response = await chat.sendMessage(Content.text(message));
      return response.text ?? "No Response!";
    } catch (e) {
      return "Lỗi: $e";
    }
  }
}
