import 'package:flutter/material.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/model/chat_ai_model.dart';
import 'package:untitled/service/chat_ai_service.dart';

class ChatAIViewModel extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ChatAiService chatAiService = ChatAiService();
  late ChatAIModel userController;
  late ChatAIModel botController;
  bool isLoading = true;

  ChatAIViewModel() {
    _init();
  }

  _init() async {
    final avatar = await LocalStorage.instance.userUrlAvatar ?? AppConstants.urlImageDefault;
    final username = await LocalStorage.instance.userName ?? "User";

    userController = ChatAIModel(
      message: [],
      role: Role.user,
      name: username,
      avatar: avatar,
      color: const Color(0xFFF1F3F5),
    );

    botController = ChatAIModel(
      message: [],
      role: Role.bot,
      name: "Bot",
      avatar: AppConstants.urlImageDefault,
      color: const Color(0xFFDBE4FF),
    );
    isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage() async {
    var text = controller.text;
    if (text.isEmpty) return;
    userController.message.add(text);
    botController.message.add("Waiting...");
    notifyListeners();
    final response = await chatAiService.sendMessage(text);
    botController.message.removeLast();
    botController.message.add(response);
    notifyListeners();
    controller.clear();
    _scrollToBottom();
  }

  void newChat() {
    userController.message.clear();
    botController.message.clear();
    notifyListeners();
  }

  Future<void> regenerateBotResponse(int index) async {
    if (index < botController.message.length) {
      botController.message[index] = "Regenerating...";
      notifyListeners();

      final response = await chatAiService.sendMessage(userController.message[index]);
      botController.message[index] = response;
      notifyListeners();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void editUserMessage(int index, String newMessage) async {
    if (newMessage.isEmpty) return;

    userController.message[index] = newMessage;

    if (index < botController.message.length) {
      botController.message[index] = "Regenerating...";
    } else {
      botController.message.add("Regenerating...");
    }
    notifyListeners();

    final response = await chatAiService.sendMessage(newMessage);
    botController.message[index] = response;
    notifyListeners();
    _scrollToBottom();
  }
}
