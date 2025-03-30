import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatAiService {
  final String apiKey = "AIzaSyAK8WQsqN61xbBAO1zU7GAkt4ojbG9EqZw";
  late GenerativeModel model;
  static final clientId = dotenv.env['GEMINI_API_KEY'] ?? '';

  ChatAiService() {
    model = GenerativeModel(model: "gemini-1.5-flash-latest", apiKey: apiKey);
  }

  Future<String> sendMessage(String message) async {
    try {
      var chat = model.startChat();
      var response = await chat.sendMessage(Content.text(message));
      return response.text ?? "Không có phản hồi!";
    } catch (e) {
      return "Lỗi: $e";
    }
  }
}
