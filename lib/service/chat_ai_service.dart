import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatAiService {
  final String apiKey = "AIzaSyCnIi13VcEHqXRlbJ8eyH2NufxoZWKWegg";
  late GenerativeModel model;

  // Need to re-check ??
  // static final clientId = dotenv.env['GEMINI_API_KEY'] ?? '';

  ChatAiService() {
    model = GenerativeModel(model: "gemini-2.5-flash", apiKey: apiKey);
  }

  Future<String> sendMessage(String message, {String? urlImage}) async {
    if (urlImage != null && urlImage.isNotEmpty) {
      // If an image URL is provided, include it in the message
      message += "Hãy đọc ảnh từ url sau: $urlImage";
    }
    try {
      var chat = model.startChat();
      var response = await chat.sendMessage(Content.text(message));
      return response.text ?? "No Response!";
    } catch (e) {
      return "Lỗi: $e";
    }
  }
}
