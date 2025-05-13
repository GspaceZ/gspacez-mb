import 'package:flutter/material.dart';
import 'package:untitled/constants/appconstants.dart';
import 'package:untitled/data/local/local_storage.dart';
import 'package:untitled/model/chat_ai_model.dart';
import 'package:untitled/service/chat_ai_service.dart';
import 'package:untitled/service/user_service.dart';
import 'package:uuid/uuid.dart';

class ChatAIViewModel extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ChatAiService chatAiService = ChatAiService();
  late ChatAIModel userController;
  late ChatAIModel botController;
  final List<ChatController> historyChat = [];
  final Uuid _uuid = const Uuid();
  String sessionId = "";
  bool isLoading = true;

  ChatAIViewModel() {
    _init();
  }

  _init() async {
    final avatar = await LocalStorage.instance.userUrlAvatar ??
        AppConstants.urlImageDefault;
    final username = await LocalStorage.instance.userName ?? "User";
    sessionId = _uuid.v4();

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
    fetchHistoryChat();
  }

  Future<void> sendMessage() async {
    var text = controller.text;
    if (text.isEmpty) return;
    userController.message.add(text);
    botController.message.add("Waiting...");
    notifyListeners();
    final response = await UserService.instance.chatAI(text, sessionId);
    botController.message.removeLast();
    botController.message.add(response.content ?? "");
    notifyListeners();
    controller.clear();
    _scrollToBottom();
  }

  void newChat() {
    userController.message.clear();
    botController.message.clear();
    sessionId = _uuid.v4();
    notifyListeners();
  }

  Future<void> regenerateBotResponse(int index) async {
    if (index < botController.message.length) {
      botController.message[index] = "Regenerating answer...";
      notifyListeners();

      final response = await UserService.instance
          .chatAI(userController.message[index], sessionId);
      botController.message[index] = response.content ?? "";
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
      botController.message[index] = "Regenerating answer...";
    } else {
      botController.message.add("Regenerating answer...");
    }
    notifyListeners();

    final response = await UserService.instance.chatAI(newMessage, sessionId);
    botController.message[index] = response.content ?? "";
    notifyListeners();
    _scrollToBottom();
  }

  fetchHistoryChat() async {
    final response = await UserService.instance.getAllChat();
    for (var chat in response) {
      final chatController = ChatController(
        id: chat.sessionId,
        nameChatSession: chat.nameChatSession,
      );
      historyChat.add(chatController);
    }
  }

  fetchHistoryChatById(String id) async {
    final response = await UserService.instance.getHistoryChat(id);
    userController.message.clear();
    botController.message.clear();
    for (var chat in response.messages!) {
      if (chat.role == "user") {
        userController.message.add(chat.message);
      } else {
        botController.message.add(chat.message);
      }
    }
    sessionId = id;
    notifyListeners();
  }
}

class ChatController {
  final String id;
  final String nameChatSession;

  ChatController({
    required this.id,
    required this.nameChatSession,
  });
}
